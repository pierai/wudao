import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// APK文件MD5签名计算工具
///
/// 使用方法：
/// ```bash
/// dart run scripts/calculate_md5.dart
/// ```
void main() async {
  // APK文件路径
  // final apkPath = '/Users/pierai/Development/projects/zkxh/robot-control-app/build/app/outputs/flutter-apk/芯禾智控Pad_V1.1.2.apk';
  final apkPath = '/Users/pierai/Downloads/芯禾智控Pad_V1.1.3_1760059703478.apk';

  print('═══════════════════════════════════════════════════════════');
  print('📦 APK MD5 签名计算工具');
  print('═══════════════════════════════════════════════════════════');
  print('');

  // 检查文件是否存在
  final file = File(apkPath);
  if (!await file.exists()) {
    print('❌ 错误：文件不存在');
    print('路径：$apkPath');
    exit(1);
  }

  // 获取文件信息
  final fileStat = await file.stat();
  final fileSizeMB = (fileStat.size / (1024 * 1024)).toStringAsFixed(2);

  print('📄 文件路径：');
  print('   $apkPath');
  print('');
  print('📊 文件大小：$fileSizeMB MB (${fileStat.size} bytes)');
  print('');
  print('⏳ 正在计算 MD5 签名...');
  print('');

  // 计算MD5
  final stopwatch = Stopwatch()..start();
  final bytes = await file.readAsBytes();
  final digest = md5.convert(bytes);
  stopwatch.stop();

  // 输出结果
  print('✅ 计算完成！');
  print('');
  print('═══════════════════════════════════════════════════════════');
  print('📝 MD5 签名值：');
  print('═══════════════════════════════════════════════════════════');
  print('');
  print('  $digest');
  print('');
  print('═══════════════════════════════════════════════════════════');
  print('');
  print('⏱️  计算耗时：${stopwatch.elapsedMilliseconds} ms');
  print('');

  // 同时输出为大写格式（某些系统可能需要）
  print('📋 其他格式：');
  print('');
  print('  大写：${digest.toString().toUpperCase()}');
  print('  小写：${digest.toString().toLowerCase()}');
  print('  Base64：${base64.encode(digest.bytes)}');
  print('');
  print('═══════════════════════════════════════════════════════════');
}
