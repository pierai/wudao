/// 打卡记录来源
///
/// 用于区分打卡是通过次日计划还是在习惯列表直接完成
enum RecordSource {
  /// 通过次日计划打卡
  fromPlan,

  /// 在习惯列表直接打卡
  fromList,
}

/// 扩展方法
extension RecordSourceX on RecordSource {
  /// 是否来自计划
  bool get isFromPlan => this == RecordSource.fromPlan;

  /// 是否来自列表
  bool get isFromList => this == RecordSource.fromList;

  /// 转换为数据库存储值
  String toDbValue() {
    switch (this) {
      case RecordSource.fromPlan:
        return 'fromPlan';
      case RecordSource.fromList:
        return 'fromList';
    }
  }

  /// 从数据库值解析
  static RecordSource fromDbValue(String value) {
    switch (value) {
      case 'fromPlan':
        return RecordSource.fromPlan;
      case 'fromList':
        return RecordSource.fromList;
      default:
        return RecordSource.fromList;
    }
  }
}
