// 自定义分段控制器 - 增大圆角
import 'package:flutter/cupertino.dart';

class CustomSegmentedControl<T extends Object> extends StatelessWidget {
  final Map<T, Widget> children;
  final T? groupValue;
  final ValueChanged<T?> onValueChanged;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? borderColor;
  final double borderRadius;

  const CustomSegmentedControl({
    super.key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.selectedColor,
    this.unselectedColor,
    this.borderColor,
    this.borderRadius = 12, // 更大的圆角
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CupertinoSlidingSegmentedControl<T>(
        groupValue: groupValue,
        onValueChanged: onValueChanged,
        backgroundColor: unselectedColor ?? CupertinoColors.tertiarySystemFill,
        thumbColor: selectedColor ??
            CupertinoColors.systemBackground.resolveFrom(context),
        children: children,
      ),
    );
  }
}
