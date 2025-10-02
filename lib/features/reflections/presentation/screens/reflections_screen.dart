import 'package:flutter/cupertino.dart';

class ReflectionsScreen extends StatelessWidget {
  const ReflectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('灵感记录'),
        trailing: Icon(CupertinoIcons.add),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.lightbulb_fill,
                size: 80,
                color: CupertinoColors.systemGrey,
              ),
              SizedBox(height: 16),
              Text(
                '记录你的灵感与感悟',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '运动、工作、生活的每一刻',
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
