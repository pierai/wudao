import 'package:drift/drift.dart';

import '../lib/core/database/app_database.dart';

/// 习惯初始化脚本
///
/// 运行方式: dart run scripts/init_habits.dart
///
/// 包含习惯列表（基于《习惯的力量》理论）：
/// 1. 穿袜子洗漱 - 正向习惯
/// 2. 穿袜子 - 正向习惯
/// 3. 每天早上整理床铺 - 正向习惯
/// 4. 每天一结一思 - 正向习惯（核心习惯）

Future<void> main() async {
  print('🚀 开始初始化习惯数据...\n');

  // 初始化数据库
  final database = AppDatabase();
  final habitDao = database.habitDao;

  final now = DateTime.now();

  // 习惯列表
  final habits = [
    // 1. 穿袜子洗澡
    HabitsCompanion.insert(
      id: 'habit_wear_socks_shower_${now.millisecondsSinceEpoch}',
      name: '穿袜子洗澡',
      cue: '袜子放在拖鞋上',
      routine: '看到拖鞋上的袜子，穿上袜子后再去洗澡',
      reward: '保持脚部清洁，避免直接接触地面',
      type: 'POSITIVE',
      category: const Value('健康'),
      notes: const Value('通过视觉提示（袜子放在显眼位置）触发行为'),
      isActive: const Value(true),
      isKeystone: const Value(false),
      createdAt: now,
      updatedAt: now,
      deletedAt: const Value(null),
    ),

    // 2. 穿袜子
    HabitsCompanion.insert(
      id: 'habit_wear_socks_${now.millisecondsSinceEpoch + 1}',
      name: '穿袜子',
      cue: '起床后看到床边的袜子',
      routine: '起床后立即穿上袜子',
      reward: '脚部保暖，避免着凉',
      type: 'POSITIVE',
      category: const Value('健康'),
      notes: const Value('早晨起床后的第一件事'),
      isActive: const Value(true),
      isKeystone: const Value(false),
      createdAt: now,
      updatedAt: now,
      deletedAt: const Value(null),
    ),

    // 3. 每天早上整理床铺
    HabitsCompanion.insert(
      id: 'habit_make_bed_${now.millisecondsSinceEpoch + 2}',
      name: '每天早上整理床铺',
      cue: '起床后看到凌乱的床铺',
      routine: '起床后立即整理床铺，铺平被子、摆正枕头',
      reward: '房间整洁有序，一天有个好开始',
      type: 'POSITIVE',
      category: const Value('生活'),
      notes: const Value('海军上将的建议：想改变世界，从整理床铺开始'),
      isActive: const Value(true),
      isKeystone: const Value(true), // 核心习惯：带动其他整理习惯
      createdAt: now,
      updatedAt: now,
      deletedAt: const Value(null),
    ),

    // 4. 每天一结一思（时事复盘）
    HabitsCompanion.insert(
      id: 'habit_daily_review_${now.millisecondsSinceEpoch + 3}',
      name: '每天一结一思',
      cue: '晚上睡觉前，看到手机上的新闻 App',
      routine: '回顾今日国家大事、时事热点，进行复盘和思考',
      reward: '有话题、有谈资，保持对时事的敏感度',
      type: 'POSITIVE',
      category: const Value('学习'),
      notes: const Value('培养独立思考能力，不人云亦云'),
      isActive: const Value(true),
      isKeystone: const Value(true), // 核心习惯：带动阅读、思考等习惯
      createdAt: now,
      updatedAt: now,
      deletedAt: const Value(null),
    ),

    // 5. 上厕所后洗手
    HabitsCompanion.insert(
      id: 'habit_wash_hands_${now.millisecondsSinceEpoch + 4}',
      name: '上厕所后洗手',
      cue: '上完厕所，看到洗手池',
      routine: '用洗手液认真洗手 20 秒',
      reward: '保持卫生，预防疾病',
      type: 'POSITIVE',
      category: const Value('健康'),
      notes: const Value('最基本的卫生习惯'),
      isActive: const Value(true),
      isKeystone: const Value(false),
      createdAt: now,
      updatedAt: now,
      deletedAt: const Value(null),
    ),

    // 如果需要添加更多习惯，请继续在这里添加...
    // 由于图片中的手写内容较难完全辨认，请根据实际需要补充
  ];

  // 批量插入习惯
  try {
    int count = 0;
    for (final habit in habits) {
      await habitDao.insertHabit(habit as HabitData);
      count++;
      print('✅ [$count/${habits.length}] ${habit.name.value} - 已添加');
    }

    print('\n🎉 成功初始化 $count 个习惯！');
    print('\n📝 习惯列表：');
    for (final habit in habits) {
      final isKeystone = habit.isKeystone.value ? ' 💎' : '';
      print('  - ${habit.name.value}$isKeystone (${habit.category.value ?? "无分类"})');
    }

    print('\n💡 提示：');
    print('  - 核心习惯（💎）会带动其他习惯的形成');
    print('  - 建议先专注于 1-2 个核心习惯，养成后再扩展');
    print('  - 每天打卡记录，21 天养成习惯！');
  } catch (e) {
    print('❌ 错误：$e');
  } finally {
    await database.close();
  }
}
