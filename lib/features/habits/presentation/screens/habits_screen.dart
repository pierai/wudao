import 'package:flutter/cupertino.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('习惯追踪'),
        trailing: Icon(CupertinoIcons.add),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.chart_bar_fill,
                size: 80,
                color: CupertinoColors.systemGrey,
              ),
              SizedBox(height: 16),
              Text(
                '培养你的核心习惯',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '基于触发机制建立习惯闭环',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
