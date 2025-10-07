import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/conflict_info.dart';
import '../../domain/entities/merge_strategy.dart';
import '../../domain/entities/import_result.dart';
import '../providers/data_transfer_provider.dart';

/// 导入页面（5步向导）
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  // 当前步骤（0-4）
  int _currentStep = 0;

  // Step 1: 文件选择
  String? _selectedFilePath;

  // Step 2: 导入预览
  List<ConflictInfo>? _conflicts;
  bool _isPreviewing = false;

  // Step 3: 冲突解决
  MergeStrategy _selectedStrategy = MergeStrategy.smartMerge;
  final Map<String, String> _manualDecisions = {}; // conflict_id -> 'new' or 'old'

  // Step 5: 结果展示
  ImportResult? _importResult;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('导入数据 (${_currentStep + 1}/5)'),
        trailing: _currentStep > 0 && _currentStep < 4
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      child: SafeArea(
        child: _buildStepContent(),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1FileSelection();
      case 1:
        return _buildStep2Preview();
      case 2:
        return _buildStep3ConflictResolution();
      case 3:
        return _buildStep4Importing();
      case 4:
        return _buildStep5Result();
      default:
        return const SizedBox();
    }
  }

  // Step 1: 文件选择
  Widget _buildStep1FileSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.doc_text,
                      color: CupertinoColors.systemBlue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '选择备份文件',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '请选择从其他设备导出的 JSON 备份文件。\n'
                  '支持从 iCloud Drive、文件 App 选择。',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 选择文件按钮
          CupertinoButton.filled(
            onPressed: _pickFile,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.folder, color: CupertinoColors.white),
                SizedBox(width: 8),
                Text('选择文件'),
              ],
            ),
          ),

          if (_selectedFilePath != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.systemGreen,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_circle_fill,
                        color: CupertinoColors.systemGreen,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '已选择文件',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedFilePath!.split('/').last,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: _goToStep2,
              child: const Text('下一步：预览数据'),
            ),
          ],

          const Spacer(),
        ],
      ),
    );
  }

  // Step 2: 导入预览
  Widget _buildStep2Preview() {
    return Column(
      children: [
        Expanded(
          child: _isPreviewing
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(),
                      SizedBox(height: 16),
                      Text('正在分析数据...'),
                    ],
                  ),
                )
              : _buildPreviewContent(),
        ),
        if (!_isPreviewing && _conflicts != null)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton.filled(
                onPressed: _goToStep3,
                child: Text(
                  _conflicts!.isEmpty ? '下一步：开始导入' : '下一步：解决冲突',
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreviewContent() {
    if (_conflicts == null) {
      return const Center(child: Text('数据加载中...'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 冲突摘要
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _conflicts!.isEmpty
                ? CupertinoColors.systemGreen.withOpacity(0.1)
                : CupertinoColors.systemOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _conflicts!.isEmpty
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.exclamationmark_triangle_fill,
                    color: _conflicts!.isEmpty
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _conflicts!.isEmpty ? '无冲突' : '检测到 ${_conflicts!.length} 个冲突',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _conflicts!.isEmpty
                    ? '所有数据可以直接导入，无需处理冲突。'
                    : '请在下一步选择如何解决这些冲突。',
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),

        if (_conflicts!.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            '冲突详情',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ..._conflicts!.map((conflict) => _buildConflictCard(conflict)),
        ],
      ],
    );
  }

  Widget _buildConflictCard(ConflictInfo conflict) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getConflictIcon(conflict.type),
                size: 20,
                color: CupertinoColors.systemOrange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  conflict.displayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            conflict.reason,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          if (conflict.recommendedAction != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.lightbulb,
                    size: 14,
                    color: CupertinoColors.systemBlue,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      conflict.recommendedAction!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getConflictIcon(ConflictType type) {
    switch (type) {
      case ConflictType.habit:
        return CupertinoIcons.square_list;
      case ConflictType.record:
        return CupertinoIcons.checkmark_circle;
      case ConflictType.plan:
        return CupertinoIcons.calendar;
      case ConflictType.frontmatter:
        return CupertinoIcons.doc_text;
    }
  }

  // Step 3: 冲突解决
  Widget _buildStep3ConflictResolution() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 策略选择
              const Text(
                '选择合并策略',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...MergeStrategy.values.map((strategy) => _buildStrategyOption(strategy)),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CupertinoButton.filled(
              onPressed: _goToStep4,
              child: const Text('开始导入'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrategyOption(MergeStrategy strategy) {
    final isSelected = _selectedStrategy == strategy;
    final isDangerous = strategy.isDangerous;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStrategy = strategy;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDangerous
                  ? CupertinoColors.systemRed.withOpacity(0.1)
                  : CupertinoColors.systemBlue.withOpacity(0.1))
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDangerous
                    ? CupertinoColors.systemRed
                    : CupertinoColors.systemBlue)
                : CupertinoColors.systemGrey5,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              color: isSelected
                  ? (isDangerous
                      ? CupertinoColors.systemRed
                      : CupertinoColors.systemBlue)
                  : CupertinoColors.systemGrey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        strategy.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          strategy.displayName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? (isDangerous
                                    ? CupertinoColors.systemRed
                                    : CupertinoColors.systemBlue)
                                : CupertinoColors.label,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strategy.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDangerous
                          ? CupertinoColors.systemRed
                          : CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: 执行导入
  Widget _buildStep4Importing() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 20),
          const SizedBox(height: 24),
          const Text(
            '正在导入数据...',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '请稍候，这可能需要一些时间',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  // Step 5: 结果展示
  Widget _buildStep5Result() {
    if (_importResult == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final isSuccess = _importResult!.isSuccess;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            isSuccess
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.xmark_circle_fill,
            size: 64,
            color: isSuccess
                ? CupertinoColors.systemGreen
                : CupertinoColors.systemRed,
          ),
          const SizedBox(height: 16),
          Text(
            isSuccess ? '导入成功' : '导入失败',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '导入统计',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildResultRow(
                  '✅ 成功导入',
                  '${_importResult!.successCount} 项',
                  CupertinoColors.systemGreen,
                ),
                if (_importResult!.mergedCount > 0)
                  _buildResultRow(
                    '⚠️ 合并处理',
                    '${_importResult!.mergedCount} 项',
                    CupertinoColors.systemOrange,
                  ),
                if (_importResult!.skippedCount > 0)
                  _buildResultRow(
                    '⏭️ 跳过',
                    '${_importResult!.skippedCount} 项',
                    CupertinoColors.systemGrey,
                  ),
                if (_importResult!.failedCount > 0)
                  _buildResultRow(
                    '❌ 失败',
                    '${_importResult!.failedCount} 项',
                    CupertinoColors.systemRed,
                  ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: CupertinoColors.separator,
                ),
                _buildResultRow(
                  '耗时',
                  '${_importResult!.durationMs}ms',
                  CupertinoColors.systemGrey,
                ),
              ],
            ),
          ),
          const Spacer(),
          CupertinoButton.filled(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('完成'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 文件选择
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  // 进入步骤 2
  Future<void> _goToStep2() async {
    setState(() {
      _currentStep = 1;
      _isPreviewing = true;
    });

    try {
      final service = ref.read(dataImportServiceProvider);
      final conflicts = await service.previewImport(_selectedFilePath!);

      if (mounted) {
        setState(() {
          _conflicts = conflicts;
          _isPreviewing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPreviewing = false;
        });

        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('预览失败'),
            content: Text('错误：$e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentStep = 0;
                  });
                },
              ),
            ],
          ),
        );
      }
    }
  }

  // 进入步骤 3
  void _goToStep3() {
    if (_conflicts!.isEmpty) {
      // 无冲突，直接进入导入
      _goToStep4();
    } else {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  // 进入步骤 4
  Future<void> _goToStep4() async {
    setState(() {
      _currentStep = 3;
    });

    try {
      final service = ref.read(dataImportServiceProvider);
      final result = await service.importFromFile(
        filePath: _selectedFilePath!,
        strategy: _selectedStrategy,
        manualDecisions: _manualDecisions.isNotEmpty ? _manualDecisions : null,
      );

      if (mounted) {
        setState(() {
          _importResult = result;
          _currentStep = 4;
        });
      }
    } catch (e) {
      if (mounted) {

        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('导入失败'),
            content: Text('错误：$e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentStep = 2;
                  });
                },
              ),
            ],
          ),
        );
      }
    }
  }
}
