import 'package:flutter/cupertino.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('人生目标'),
        trailing: Icon(CupertinoIcons.add),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.flag_fill,
                size: 80,
                color: CupertinoColors.systemGrey,
              ),
              SizedBox(height: 16),
              Text(
                '开始规划你的人生目标',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '以终为始，设定你的五层目标树',
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
