import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/data_export_service.dart';
import '../providers/data_transfer_provider.dart';

/// 数据导出页面
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _includeDeleted = false;
  int _dateRangeDays = 0; // 0 = 全部，7 = 最近7天，30 = 最近30天
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('导出数据'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 说明文本
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
                        CupertinoIcons.info_circle,
                        color: CupertinoColors.systemBlue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '导出说明',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '导出的数据可以通过 AirDrop、邮件等方式分享到其他设备，'
                    '然后在目标设备上导入，实现数据同步。',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 导出范围
            _buildSection(
              title: '导出范围',
              children: [
                _buildSegmentedControl(),
              ],
            ),

            const SizedBox(height: 16),

            // 导出选项
            _buildSection(
              title: '导出选项',
              children: [
                _buildSwitch(
                  label: '包含已删除的数据',
                  value: _includeDeleted,
                  onChanged: (value) {
                    setState(() {
                      _includeDeleted = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 导出按钮
            CupertinoButton.filled(
              onPressed: _isExporting ? null : _handleExport,
              child: _isExporting
                  ? const CupertinoActivityIndicator(
                      color: CupertinoColors.white,
                    )
                  : const Text('导出并分享'),
            ),

            const SizedBox(height: 16),

            // 预览信息
            _buildPreviewInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        CupertinoListSection.insetGrouped(
          margin: EdgeInsets.zero,
          children: children,
        ),
      ],
    );
  }

  Widget _buildSegmentedControl() {
    return CupertinoListTile(
      title: const Text('选择时间范围'),
      trailing: SizedBox(
        width: 200,
        child: CupertinoSlidingSegmentedControl<int>(
          groupValue: _dateRangeDays,
          children: const {
            0: Text('全部'),
            7: Text('7天'),
            30: Text('30天'),
          },
          onValueChanged: (value) {
            setState(() {
              _dateRangeDays = value ?? 0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CupertinoListTile(
      title: Text(label),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPreviewInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '导出格式',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'JSON 格式 (.json)',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getDateRangeDescription(),
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  String _getDateRangeDescription() {
    if (_dateRangeDays == 0) {
      return '包含所有数据';
    } else {
      return '包含最近 $_dateRangeDays 天的数据';
    }
  }

  Future<void> _handleExport() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final service = ref.read(dataExportServiceProvider);

      DateTimeRange? dateRange;
      if (_dateRangeDays > 0) {
        dateRange = DateTimeRange.lastDays(_dateRangeDays);
      }

      // 导出并分享
      await service.exportAndShare(
        includeDeleted: _includeDeleted,
        dateRange: dateRange,
      );

      if (!mounted) return;

      // 显示成功提示
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('导出成功'),
          content: const Text('数据已准备好分享，请选择分享方式。'),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 返回上一页
              },
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // 显示错误提示
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('导出失败'),
          content: Text('错误：$e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }
}
