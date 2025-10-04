import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit_record.dart';
import '../providers/habit_provider.dart';

/// 习惯日历热力图组件
///
/// GitHub 风格的年度热力图
/// - 颜色深浅表示完成质量（1-5 星对应渐变色）
/// - 点击日期显示详情
/// - 支持滚动查看历史数据
class HabitCalendarHeatmap extends ConsumerStatefulWidget {
  final String habitId;
  final int monthsToShow; // 显示多少个月的数据

  const HabitCalendarHeatmap({
    super.key,
    required this.habitId,
    this.monthsToShow = 6, // 默认显示最近 6 个月
  });

  @override
  ConsumerState<HabitCalendarHeatmap> createState() =>
      _HabitCalendarHeatmapState();
}

class _HabitCalendarHeatmapState
    extends ConsumerState<HabitCalendarHeatmap> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(habitRecordsProvider(widget.habitId));

    return recordsAsync.when(
      data: (records) {
        final heatmapData = _buildHeatmapData(records);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '打卡日历',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildLegend(),
            const SizedBox(height: 12),
            SizedBox(
              height: 150, // 7 rows * (cell height + spacing)
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: _buildHeatmap(heatmapData),
              ),
            ),
          ],
        );
      },
      loading: () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          '日历加载失败',
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemRed,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        const Text(
          '少',
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Container(
            margin: const EdgeInsets.only(right: 4),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getColorForQuality(index + 1),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text(
          '多',
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmap(Map<DateTime, List<HabitRecord>> heatmapData) {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day);
    final startDate = endDate.subtract(Duration(days: widget.monthsToShow * 30));

    // 计算需要显示的周数
    final weeksDiff = (endDate.difference(startDate).inDays / 7).ceil();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(weeksDiff, (weekIndex) {
        final weekStart = startDate.add(Duration(days: weekIndex * 7));

        return Column(
          children: List.generate(7, (dayIndex) {
            final date = weekStart.add(Duration(days: dayIndex));

            // 如果日期超过今天，不显示
            if (date.isAfter(endDate)) {
              return const SizedBox(width: 20, height: 20);
            }

            final dateKey = DateTime(date.year, date.month, date.day);
            final dayRecords = heatmapData[dateKey] ?? [];

            return GestureDetector(
              onTap: dayRecords.isNotEmpty
                  ? () => _showDayDetail(date, dayRecords)
                  : null,
              child: Container(
                margin: const EdgeInsets.all(2),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getCellColor(dayRecords),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: CupertinoColors.separator.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Map<DateTime, List<HabitRecord>> _buildHeatmapData(
      List<HabitRecord> records) {
    final Map<DateTime, List<HabitRecord>> heatmapData = {};

    for (final record in records) {
      final dateKey = DateTime(
        record.executedAt.year,
        record.executedAt.month,
        record.executedAt.day,
      );

      if (heatmapData.containsKey(dateKey)) {
        heatmapData[dateKey]!.add(record);
      } else {
        heatmapData[dateKey] = [record];
      }
    }

    return heatmapData;
  }

  Color _getCellColor(List<HabitRecord> dayRecords) {
    if (dayRecords.isEmpty) {
      return CupertinoColors.systemGrey6;
    }

    // 使用该天所有记录的平均质量
    final avgQuality =
        dayRecords.map((r) => r.quality ?? 3).reduce((a, b) => a + b) /
            dayRecords.length;

    return _getColorForQuality(avgQuality.round());
  }

  Color _getColorForQuality(int quality) {
    // 绿色渐变：质量越高，颜色越深
    switch (quality) {
      case 1:
        return CupertinoColors.activeGreen.withOpacity(0.2);
      case 2:
        return CupertinoColors.activeGreen.withOpacity(0.4);
      case 3:
        return CupertinoColors.activeGreen.withOpacity(0.6);
      case 4:
        return CupertinoColors.activeGreen.withOpacity(0.8);
      case 5:
        return CupertinoColors.activeGreen;
      default:
        return CupertinoColors.systemGrey6;
    }
  }

  void _showDayDetail(DateTime date, List<HabitRecord> records) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(_formatDate(date)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('打卡次数：${records.length}'),
            const SizedBox(height: 8),
            ...records.map((record) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatTime(record.executedAt)),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        final quality = record.quality ?? 3;
                        return Icon(
                          index < quality
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                          size: 14,
                          color: CupertinoColors.systemYellow,
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
