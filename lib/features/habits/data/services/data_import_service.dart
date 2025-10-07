import 'dart:convert';
import 'dart:io';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/export_data.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/habit_frontmatter.dart';
import '../../domain/entities/conflict_info.dart';
import '../../domain/entities/merge_strategy.dart';
import '../../domain/entities/import_result.dart';
import '../../domain/repositories/habit_repository.dart';
import 'data_export_service.dart';

/// 数据导入服务
///
/// 负责从 JSON 文件导入数据，处理冲突和合并
class DataImportService {
  final HabitRepository _habitRepository;
  final DataExportService _exportService;
  final AppDatabase _database;

  DataImportService(
    this._habitRepository,
    this._exportService,
    this._database,
  );

  /// 从文件导入数据
  ///
  /// [filePath] 导入文件路径
  /// [strategy] 合并策略
  /// [backupBeforeImport] 是否在导入前备份（默认 true）
  Future<ImportResult> importFromFile({
    required String filePath,
    required MergeStrategy strategy,
    bool backupBeforeImport = true,
    Map<String, dynamic>? manualDecisions, // 手动决策（用于手动模式）
  }) async {
    final startTime = DateTime.now();
    final errors = <String>[];

    try {
      // 1. 读取文件
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('文件不存在：$filePath');
      }

      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // 2. 解析导出数据
      final exportData = ExportData.fromJson(json);

      // 3. 验证导出数据版本
      if (exportData.version != '1.0.0') {
        throw Exception('不支持的导出格式版本：${exportData.version}');
      }

      // 4. 导入前备份
      if (backupBeforeImport) {
        await _createBackup();
      }

      // 5. 检测冲突
      final conflicts = await _detectConflicts(exportData);

      // 6. 使用事务导入数据
      final result = await _database.transaction(() async {
        return await _importDataWithStrategy(
          exportData,
          conflicts,
          strategy,
          manualDecisions,
        );
      });

      // 7. 计算耗时
      final duration = DateTime.now().difference(startTime);

      return result.copyWith(durationMs: duration.inMilliseconds);
    } catch (e) {
      errors.add('导入失败：$e');
      return ImportResult(
        failedCount: 1,
        errors: errors,
        durationMs: DateTime.now().difference(startTime).inMilliseconds,
      );
    }
  }

  /// 预览导入（检测冲突，不执行导入）
  Future<List<ConflictInfo>> previewImport(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('文件不存在：$filePath');
    }

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final exportData = ExportData.fromJson(json);

    return await _detectConflicts(exportData);
  }

  /// 检测冲突
  Future<List<ConflictInfo>> _detectConflicts(ExportData exportData) async {
    final conflicts = <ConflictInfo>[];

    // 1. 检测习惯冲突
    for (final habitJson in exportData.habits) {
      final imported = Habit.fromJson(habitJson);
      final existing = await _habitRepository.getHabitById(imported.id);

      if (existing != null) {
        // ID 冲突：检查内容是否一致
        if (_isHabitDifferent(existing, imported)) {
          conflicts.add(ConflictInfo.habit(
            current: existing,
            imported: imported,
          ));
        }
      }
    }

    // 2. 检测打卡记录冲突
    final allRecords = <HabitRecord>[];
    for (final habitJson in exportData.habits) {
      final habitId = habitJson['id'] as String;
      final records = await _habitRepository.getRecordsByHabitId(habitId);
      allRecords.addAll(records);
    }

    for (final recordJson in exportData.records) {
      final imported = HabitRecord.fromJson(recordJson);
      final existing = await _habitRepository.getRecordOnDate(
        imported.habitId,
        imported.executedAt,
      );

      if (existing != null) {
        // 同一天同一习惯的打卡记录冲突
        if (_isRecordDifferent(existing, imported)) {
          conflicts.add(ConflictInfo.record(
            current: existing,
            imported: imported,
          ));
        }
      }
    }

    return conflicts;
  }

  /// 使用指定策略导入数据
  Future<ImportResult> _importDataWithStrategy(
    ExportData exportData,
    List<ConflictInfo> conflicts,
    MergeStrategy strategy,
    Map<String, dynamic>? manualDecisions,
  ) async {
    int successCount = 0;
    int skippedCount = 0;
    int mergedCount = 0;
    int failedCount = 0;
    final errors = <String>[];

    try {
      // 完全覆盖策略：先清空所有数据
      if (strategy == MergeStrategy.replaceAll) {
        await _clearAllData();
        // 清空后，所有数据都视为无冲突，直接导入
        return await _importAllDataDirect(exportData);
      }

      // 创建冲突 ID 映射
      final conflictIds = conflicts.map((c) => c.conflictId).toSet();

      // 1. 导入习惯
      for (final habitJson in exportData.habits) {
        try {
          final imported = Habit.fromJson(habitJson);
          final hasConflict = conflictIds.contains(imported.id);

          if (hasConflict) {
            // 根据策略处理冲突
            final action = _resolveConflict(
              imported.id,
              strategy,
              manualDecisions,
              conflicts,
            );

            if (action == ConflictAction.keepNew) {
              await _habitRepository.updateHabit(imported);
              mergedCount++;
            } else if (action == ConflictAction.keepOld) {
              skippedCount++;
            }
          } else {
            // 无冲突，直接导入
            await _habitRepository.createHabit(imported);
            successCount++;
          }
        } catch (e) {
          errors.add('导入习惯失败（${habitJson['name']}）：$e');
          failedCount++;
        }
      }

      // 2. 导入打卡记录
      for (final recordJson in exportData.records) {
        try {
          final imported = HabitRecord.fromJson(recordJson);
          final hasConflict = conflictIds.contains(imported.id);

          if (hasConflict) {
            final action = _resolveConflict(
              imported.id,
              strategy,
              manualDecisions,
              conflicts,
            );

            if (action == ConflictAction.keepNew) {
              await _habitRepository.updateRecord(imported);
              mergedCount++;
            } else if (action == ConflictAction.keepOld) {
              skippedCount++;
            }
          } else {
            await _habitRepository.recordExecution(imported);
            successCount++;
          }
        } catch (e) {
          errors.add('导入打卡记录失败：$e');
          failedCount++;
        }
      }

      // 3. 导入计划（计划通常直接合并，不覆盖）
      for (final planJson in exportData.plans) {
        try {
          final imported = DailyPlan.fromJson(planJson);

          // 检查是否已存在相同日期的计划
          final existing = await _habitRepository.getPlansByDate(imported.planDate);
          final duplicate = existing.any((p) => p.id == imported.id);

          if (duplicate) {
            skippedCount++;
          } else {
            await _habitRepository.createDailyPlan(imported);
            successCount++;
          }
        } catch (e) {
          errors.add('导入计划失败：$e');
          failedCount++;
        }
      }

      // 4. 导入 Frontmatters
      for (final frontmatterJson in exportData.frontmatters) {
        try {
          final imported = HabitFrontmatter.fromJson(frontmatterJson);
          final existing = await _habitRepository.getFrontmatterById(imported.id);

          if (existing != null) {
            // 根据更新时间决定是否覆盖
            if (imported.updatedAt.isAfter(existing.updatedAt)) {
              await _habitRepository.updateFrontmatter(imported);
              mergedCount++;
            } else {
              skippedCount++;
            }
          } else {
            await _habitRepository.createFrontmatter(imported);
            successCount++;
          }
        } catch (e) {
          errors.add('导入 Frontmatter 失败：$e');
          failedCount++;
        }
      }

      return ImportResult(
        successCount: successCount,
        skippedCount: skippedCount,
        mergedCount: mergedCount,
        failedCount: failedCount,
        errors: errors,
      );
    } catch (e) {
      throw Exception('导入事务失败：$e');
    }
  }

  /// 解决冲突（根据策略）
  ConflictAction _resolveConflict(
    String conflictId,
    MergeStrategy strategy,
    Map<String, dynamic>? manualDecisions,
    List<ConflictInfo> conflicts,
  ) {
    switch (strategy) {
      case MergeStrategy.keepNew:
        return ConflictAction.keepNew;

      case MergeStrategy.keepOld:
        return ConflictAction.keepOld;

      case MergeStrategy.smartMerge:
        // 根据更新时间自动选择
        final conflict = conflicts.firstWhere((c) => c.conflictId == conflictId);
        final currentUpdatedAt = conflict.currentData['updated_at'] as String?;
        final importedUpdatedAt = conflict.importData['updated_at'] as String?;

        if (currentUpdatedAt != null && importedUpdatedAt != null) {
          final current = DateTime.parse(currentUpdatedAt);
          final imported = DateTime.parse(importedUpdatedAt);
          return imported.isAfter(current)
              ? ConflictAction.keepNew
              : ConflictAction.keepOld;
        }
        return ConflictAction.keepOld; // 默认保留旧数据

      case MergeStrategy.manual:
        // 从手动决策中获取
        if (manualDecisions != null && manualDecisions.containsKey(conflictId)) {
          final decision = manualDecisions[conflictId] as String;
          return decision == 'new'
              ? ConflictAction.keepNew
              : ConflictAction.keepOld;
        }
        return ConflictAction.keepOld; // 默认保留旧数据
    }
  }

  /// 创建导入前备份
  Future<void> _createBackup() async {
    await _exportService.exportToFile();
    // 备份文件已自动保存，无需额外操作
  }

  /// 判断习惯是否不同
  bool _isHabitDifferent(Habit current, Habit imported) {
    return current.name != imported.name ||
        current.cue != imported.cue ||
        current.routine != imported.routine ||
        current.reward != imported.reward ||
        current.type != imported.type ||
        current.category != imported.category ||
        current.notes != imported.notes ||
        current.isKeystone != imported.isKeystone;
  }

  /// 判断打卡记录是否不同
  bool _isRecordDifferent(HabitRecord current, HabitRecord imported) {
    return current.quality != imported.quality || current.notes != imported.notes;
  }

  /// 清空所有数据（用于完全覆盖策略）
  Future<void> _clearAllData() async {
    // 删除所有表的数据（保留表结构）
    await _database.delete(_database.habitFrontmatters).go();
    await _database.delete(_database.dailyPlans).go();
    await _database.delete(_database.habitRecords).go();
    await _database.delete(_database.habits).go();
    // 注意：goals 表暂时不清空，因为导入数据不包含目标
  }

  /// 直接导入所有数据（无冲突检测，用于完全覆盖策略）
  Future<ImportResult> _importAllDataDirect(ExportData exportData) async {
    int successCount = 0;
    int failedCount = 0;
    final errors = <String>[];

    try {
      // 1. 导入习惯
      for (final habitJson in exportData.habits) {
        try {
          final habit = Habit.fromJson(habitJson);
          await _habitRepository.createHabit(habit);
          successCount++;
        } catch (e) {
          errors.add('导入习惯失败（${habitJson['name']}）：$e');
          failedCount++;
        }
      }

      // 2. 导入打卡记录
      for (final recordJson in exportData.records) {
        try {
          final record = HabitRecord.fromJson(recordJson);
          await _habitRepository.recordExecution(record);
          successCount++;
        } catch (e) {
          errors.add('导入打卡记录失败：$e');
          failedCount++;
        }
      }

      // 3. 导入次日计划
      for (final planJson in exportData.plans) {
        try {
          final plan = DailyPlan.fromJson(planJson);
          await _habitRepository.createDailyPlan(plan);
          successCount++;
        } catch (e) {
          errors.add('导入次日计划失败：$e');
          failedCount++;
        }
      }

      // 4. 导入 Frontmatter
      for (final frontmatterJson in exportData.frontmatters) {
        try {
          final frontmatter = HabitFrontmatter.fromJson(frontmatterJson);
          await _habitRepository.createFrontmatter(frontmatter);
          successCount++;
        } catch (e) {
          errors.add('导入 Frontmatter 失败：$e');
          failedCount++;
        }
      }

      return ImportResult(
        successCount: successCount,
        failedCount: failedCount,
        errors: errors,
      );
    } catch (e) {
      return ImportResult(
        failedCount: failedCount + 1,
        errors: [...errors, '导入过程发生错误：$e'],
      );
    }
  }
}

/// 冲突解决动作
enum ConflictAction {
  /// 保留新数据
  keepNew,

  /// 保留旧数据
  keepOld,
}
