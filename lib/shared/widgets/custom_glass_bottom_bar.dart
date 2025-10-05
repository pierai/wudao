// 自定义玻璃态底部导航栏
// 优化自 liquid_glass_bottom_bar，增大圆角，优化颜色

import 'dart:ui';
import 'package:flutter/material.dart';

class CustomGlassBottomBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int? badge;

  const CustomGlassBottomBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });
}

class CustomGlassBottomBar extends StatelessWidget {
  final List<CustomGlassBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Auto height: 74 (with labels) / 56 (without labels)
  final double? height;
  final EdgeInsetsGeometry margin;
  final bool showLabels;

  /// Accent color for the active item (icon/label).
  final Color activeColor;

  /// Blur intensity for the bar and for the active pill.
  final double barBlurSigma;
  final double activeBlurSigma;

  /// Border radius (default: 32 for larger corners)
  final double borderRadius;

  /// Background opacity (0-255, default: 25 for less gray)
  final int backgroundAlpha;

  const CustomGlassBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height,
    this.margin = const EdgeInsets.fromLTRB(12, 0, 12, 12),
    this.showLabels = true,
    this.activeColor = const Color(0xFF007AFF), // iOS系统蓝
    this.barBlurSigma = 25,
    this.activeBlurSigma = 32,
    this.borderRadius = 32, // 更大的圆角
    this.backgroundAlpha = 25, // 更透明，不那么灰
  }) : assert(items.length >= 2, 'At least 2 items are required.');

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double barH = height ?? (showLabels ? 74.0 : 56.0);
    final double bottomSafe = media.padding.bottom * 0.35;

    return SafeArea(
      top: false,
      child: Padding(
        padding: margin.add(EdgeInsets.only(bottom: bottomSafe)),
        child: SizedBox(
          height: barH,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              children: [
                // Bar frosted background (global blur, no borders)
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: barBlurSigma,
                        sigmaY: barBlurSigma,
                      ),
                      child: Container(
                        color: Colors.white.withAlpha(backgroundAlpha),
                      ),
                    ),
                  ),
                ),
                // Soft drop shadow (no outline)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sliding pill (single instance)
                _SlidingActivePill(
                  items: items,
                  currentIndex: currentIndex,
                  barHeight: barH,
                  blurSigma: activeBlurSigma,
                  showLabels: showLabels,
                  pillBorderRadius: borderRadius * 0.6, // pill圆角比bar小一些
                ),

                // Items on top
                Row(
                  children: List.generate(items.length, (i) {
                    final it = items[i];
                    final selected = i == currentIndex;
                    final iconColor =
                        selected ? activeColor : Colors.white.withAlpha(200);
                    final textColor =
                        selected ? activeColor : Colors.white.withAlpha(220);

                    return Expanded(
                      child: InkWell(
                        onTap: () => onTap(i),
                        customBorder: const StadiumBorder(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: showLabels ? 10 : 8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    selected
                                        ? (it.activeIcon ?? it.icon)
                                        : it.icon,
                                    size: 22,
                                    color: iconColor,
                                  ),
                                  if ((it.badge ?? 0) > 0)
                                    Positioned(
                                      right: -8,
                                      top: -6,
                                      child: _Badge(count: it.badge!),
                                    ),
                                ],
                              ),
                              if (showLabels) ...[
                                const SizedBox(height: 4),
                                Text(
                                  it.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: textColor,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SINGLE pill sliding between items.
class _SlidingActivePill extends StatelessWidget {
  final List<CustomGlassBottomBarItem> items;
  final int currentIndex;
  final double barHeight;
  final double blurSigma;
  final bool showLabels;
  final double pillBorderRadius;

  const _SlidingActivePill({
    required this.items,
    required this.currentIndex,
    required this.barHeight,
    required this.blurSigma,
    required this.showLabels,
    required this.pillBorderRadius,
  });

  double _textWidth(String text, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return tp.width;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final slots = items.length;
      final slotW = c.maxWidth / slots;
      final vPad = showLabels ? 8.0 : 6.0;
      final pillH = barHeight - vPad * 2;

      // Pill width based on the active tab content
      final contentW = showLabels
          ? 24 + 6 + _textWidth(items[currentIndex].label, slotW)
          : 24;
      final padH = showLabels ? 20.0 : 14.0;
      final pillW = (contentW + padH * 2).clamp(48.0, slotW - 12.0);

      // Left offset to center the pill within the current slot
      final left = slotW * currentIndex + (slotW - pillW) / 2;

      return Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            left: left,
            top: vPad,
            width: pillW,
            height: pillH,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(pillBorderRadius),
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Strong blur (glass)
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurSigma,
                        sigmaY: blurSigma,
                      ),
                      child: const SizedBox.expand(),
                    ),
                    // Minimal veil (almost pure blur)
                    Container(color: Colors.white.withAlpha(12)),
                    // Top highlight
                    IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(pillBorderRadius),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withAlpha(50),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFF3B30), // iOS红色
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(200), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
