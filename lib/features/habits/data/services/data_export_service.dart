import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/export_data.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/habit_frontmatter.dart';
import '../../domain/repositories/habit_repository.dart';

/// 数据导出服务
///
/// 负责将习惯数据导出为 JSON/CSV/Markdown 格式
class DataExportService {
  final HabitRepository _habitRepository;

  DataExportService(this._habitRepository);

  /// 导出所有数据为 JSON 格式
  ///
  /// [includeDeleted] 是否包含已删除的数据
  /// [dateRange] 日期范围筛选（可选）
  Future<ExportData> exportToJson({
    bool includeDeleted = false,
    DateTimeRange? dateRange,
  }) async {
    // 1. 获取所有数据
    final habits = await _habitRepository.getAllHabits(includeDeleted: includeDeleted);

    // 2. 获取打卡记录（如果指定了日期范围，则筛选）
    List<HabitRecord> allRecords = [];
    for (final habit in habits) {
      final records = await _habitRepository.getRecordsByHabitId(habit.id);
      allRecords.addAll(records);
    }

    // 应用日期范围筛选
    if (dateRange != null) {
      allRecords = allRecords.where((record) {
        return record.executedAt.isAfter(dateRange.start) &&
            record.executedAt.isBefore(dateRange.end);
      }).toList();
    }

    // 3. 获取计划
    final plans = await _habitRepository.getAllPlans();

    // 4. 获取 Frontmatters
    final frontmatters = await _habitRepository.getAllFrontmatters();

    // 5. 获取设备信息
    final deviceInfo = await _getDeviceInfo();

    // 6. 创建导出数据
    return ExportData.create(
      appVersion: '0.1.0', // TODO: 从 package_info 获取
      deviceInfo: deviceInfo,
      habits: habits,
      records: allRecords,
      plans: plans,
      frontmatters: frontmatters,
    );
  }

  /// 导出数据并保存到文件
  ///
  /// 返回文件路径
  Future<String> exportToFile({
    bool includeDeleted = false,
    DateTimeRange? dateRange,
  }) async {
    // 1. 导出数据
    final exportData = await exportToJson(
      includeDeleted: includeDeleted,
      dateRange: dateRange,
    );

    // 2. 转换为 JSON 字符串
    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData.toJson());

    // 3. 生成文件名
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'wudao_backup_$timestamp.json';

    // 4. 获取文档目录
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';

    // 5. 写入文件
    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  /// 导出并分享文件（通过 AirDrop/邮件等）
  Future<void> exportAndShare({
    bool includeDeleted = false,
    DateTimeRange? dateRange,
  }) async {
    // 1. 导出到文件
    final filePath = await exportToFile(
      includeDeleted: includeDeleted,
      dateRange: dateRange,
    );

    // 2. 分享文件
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: '悟道 - 习惯数据备份',
      text: '这是您的习惯追踪数据备份文件，可以导入到其他设备。',
    );
  }

  /// 获取设备信息
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return {
        'device_type': 'iPhone',
        'device_model': iosInfo.model,
        'os_version': 'iOS ${iosInfo.systemVersion}',
      };
    } else if (Platform.isMacOS) {
      final macosInfo = await deviceInfoPlugin.macOsInfo;
      return {
        'device_type': 'macOS',
        'device_model': macosInfo.model,
        'os_version': 'macOS ${macosInfo.osRelease}',
      };
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return {
        'device_type': 'Android',
        'device_model': androidInfo.model,
        'os_version': 'Android ${androidInfo.version.release}',
      };
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfoPlugin.windowsInfo;
      return {
        'device_type': 'Windows',
        'device_model': windowsInfo.computerName,
        'os_version': 'Windows ${windowsInfo.majorVersion}.${windowsInfo.minorVersion}',
      };
    } else {
      return {
        'device_type': 'Unknown',
        'device_model': 'Unknown',
        'os_version': 'Unknown',
      };
    }
  }

  /// 列出本地备份文件
  Future<List<File>> listBackupFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);

    final files = await dir
        .list()
        .where((entity) =>
            entity is File &&
            entity.path.endsWith('.json') &&
            entity.path.contains('wudao_backup'))
        .cast<File>()
        .toList();

    // 按修改时间倒序排列（最新的在前）
    files.sort((a, b) {
      final aStat = a.statSync();
      final bStat = b.statSync();
      return bStat.modified.compareTo(aStat.modified);
    });

    return files;
  }

  /// 清理旧备份（保留最近 N 个）
  Future<void> cleanOldBackups({int keepCount = 5}) async {
    final backups = await listBackupFiles();

    if (backups.length > keepCount) {
      final toDelete = backups.sublist(keepCount);
      for (final file in toDelete) {
        await file.delete();
      }
    }
  }
}

/// 日期范围
class DateTimeRange {
  final DateTime start;
  final DateTime end;

  DateTimeRange({required this.start, required this.end});

  /// 最近 N 天
  factory DateTimeRange.lastDays(int days) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    return DateTimeRange(start: start, end: end);
  }

  /// 最近 N 周
  factory DateTimeRange.lastWeeks(int weeks) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: weeks * 7));
    return DateTimeRange(start: start, end: end);
  }
}
