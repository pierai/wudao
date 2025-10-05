// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyPlan {

/// 唯一标识符
 String get id;/// 计划日期
 DateTime get planDate;/// 关联的习惯 ID
 String get habitId;/// 暗示任务：基于习惯的 cue 生成的具体任务描述
 String get cueTask;/// 计划执行时间（可选）
 DateTime? get scheduledTime;/// 优先级（0-10，数字越小优先级越高）
 int get priority;/// 计划完成状态
 PlanCompletionStatus get status;/// 暗示完成时间
 DateTime? get cueCompletedAt;/// 打卡时间
 DateTime? get checkedInAt;/// 关联的打卡记录 ID
 String? get recordId;/// 创建时间
 DateTime get createdAt;/// 更新时间
 DateTime? get updatedAt;// ==================== 废弃字段(向后兼容) ====================
/// @deprecated 使用 status 替代
@Deprecated('Use status instead') bool get isCompleted;/// @deprecated 使用 checkedInAt 替代
@Deprecated('Use checkedInAt instead') DateTime? get completedAt;
/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyPlanCopyWith<DailyPlan> get copyWith => _$DailyPlanCopyWithImpl<DailyPlan>(this as DailyPlan, _$identity);

  /// Serializes this DailyPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.planDate, planDate) || other.planDate == planDate)&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.cueTask, cueTask) || other.cueTask == cueTask)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.cueCompletedAt, cueCompletedAt) || other.cueCompletedAt == cueCompletedAt)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,planDate,habitId,cueTask,scheduledTime,priority,status,cueCompletedAt,checkedInAt,recordId,createdAt,updatedAt,isCompleted,completedAt);

@override
String toString() {
  return 'DailyPlan(id: $id, planDate: $planDate, habitId: $habitId, cueTask: $cueTask, scheduledTime: $scheduledTime, priority: $priority, status: $status, cueCompletedAt: $cueCompletedAt, checkedInAt: $checkedInAt, recordId: $recordId, createdAt: $createdAt, updatedAt: $updatedAt, isCompleted: $isCompleted, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $DailyPlanCopyWith<$Res>  {
  factory $DailyPlanCopyWith(DailyPlan value, $Res Function(DailyPlan) _then) = _$DailyPlanCopyWithImpl;
@useResult
$Res call({
 String id, DateTime planDate, String habitId, String cueTask, DateTime? scheduledTime, int priority, PlanCompletionStatus status, DateTime? cueCompletedAt, DateTime? checkedInAt, String? recordId, DateTime createdAt, DateTime? updatedAt,@Deprecated('Use status instead') bool isCompleted,@Deprecated('Use checkedInAt instead') DateTime? completedAt
});




}
/// @nodoc
class _$DailyPlanCopyWithImpl<$Res>
    implements $DailyPlanCopyWith<$Res> {
  _$DailyPlanCopyWithImpl(this._self, this._then);

  final DailyPlan _self;
  final $Res Function(DailyPlan) _then;

/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? planDate = null,Object? habitId = null,Object? cueTask = null,Object? scheduledTime = freezed,Object? priority = null,Object? status = null,Object? cueCompletedAt = freezed,Object? checkedInAt = freezed,Object? recordId = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isCompleted = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,planDate: null == planDate ? _self.planDate : planDate // ignore: cast_nullable_to_non_nullable
as DateTime,habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,cueTask: null == cueTask ? _self.cueTask : cueTask // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanCompletionStatus,cueCompletedAt: freezed == cueCompletedAt ? _self.cueCompletedAt : cueCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyPlan].
extension DailyPlanPatterns on DailyPlan {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyPlan value)  $default,){
final _that = this;
switch (_that) {
case _DailyPlan():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyPlan value)?  $default,){
final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime planDate,  String habitId,  String cueTask,  DateTime? scheduledTime,  int priority,  PlanCompletionStatus status,  DateTime? cueCompletedAt,  DateTime? checkedInAt,  String? recordId,  DateTime createdAt,  DateTime? updatedAt, @Deprecated('Use status instead')  bool isCompleted, @Deprecated('Use checkedInAt instead')  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
return $default(_that.id,_that.planDate,_that.habitId,_that.cueTask,_that.scheduledTime,_that.priority,_that.status,_that.cueCompletedAt,_that.checkedInAt,_that.recordId,_that.createdAt,_that.updatedAt,_that.isCompleted,_that.completedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime planDate,  String habitId,  String cueTask,  DateTime? scheduledTime,  int priority,  PlanCompletionStatus status,  DateTime? cueCompletedAt,  DateTime? checkedInAt,  String? recordId,  DateTime createdAt,  DateTime? updatedAt, @Deprecated('Use status instead')  bool isCompleted, @Deprecated('Use checkedInAt instead')  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _DailyPlan():
return $default(_that.id,_that.planDate,_that.habitId,_that.cueTask,_that.scheduledTime,_that.priority,_that.status,_that.cueCompletedAt,_that.checkedInAt,_that.recordId,_that.createdAt,_that.updatedAt,_that.isCompleted,_that.completedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime planDate,  String habitId,  String cueTask,  DateTime? scheduledTime,  int priority,  PlanCompletionStatus status,  DateTime? cueCompletedAt,  DateTime? checkedInAt,  String? recordId,  DateTime createdAt,  DateTime? updatedAt, @Deprecated('Use status instead')  bool isCompleted, @Deprecated('Use checkedInAt instead')  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
return $default(_that.id,_that.planDate,_that.habitId,_that.cueTask,_that.scheduledTime,_that.priority,_that.status,_that.cueCompletedAt,_that.checkedInAt,_that.recordId,_that.createdAt,_that.updatedAt,_that.isCompleted,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyPlan extends DailyPlan {
  const _DailyPlan({required this.id, required this.planDate, required this.habitId, required this.cueTask, this.scheduledTime, required this.priority, this.status = PlanCompletionStatus.pending, this.cueCompletedAt, this.checkedInAt, this.recordId, required this.createdAt, this.updatedAt, @Deprecated('Use status instead') this.isCompleted = false, @Deprecated('Use checkedInAt instead') this.completedAt}): super._();
  factory _DailyPlan.fromJson(Map<String, dynamic> json) => _$DailyPlanFromJson(json);

/// 唯一标识符
@override final  String id;
/// 计划日期
@override final  DateTime planDate;
/// 关联的习惯 ID
@override final  String habitId;
/// 暗示任务：基于习惯的 cue 生成的具体任务描述
@override final  String cueTask;
/// 计划执行时间（可选）
@override final  DateTime? scheduledTime;
/// 优先级（0-10，数字越小优先级越高）
@override final  int priority;
/// 计划完成状态
@override@JsonKey() final  PlanCompletionStatus status;
/// 暗示完成时间
@override final  DateTime? cueCompletedAt;
/// 打卡时间
@override final  DateTime? checkedInAt;
/// 关联的打卡记录 ID
@override final  String? recordId;
/// 创建时间
@override final  DateTime createdAt;
/// 更新时间
@override final  DateTime? updatedAt;
// ==================== 废弃字段(向后兼容) ====================
/// @deprecated 使用 status 替代
@override@JsonKey()@Deprecated('Use status instead') final  bool isCompleted;
/// @deprecated 使用 checkedInAt 替代
@override@Deprecated('Use checkedInAt instead') final  DateTime? completedAt;

/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyPlanCopyWith<_DailyPlan> get copyWith => __$DailyPlanCopyWithImpl<_DailyPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.planDate, planDate) || other.planDate == planDate)&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.cueTask, cueTask) || other.cueTask == cueTask)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.cueCompletedAt, cueCompletedAt) || other.cueCompletedAt == cueCompletedAt)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,planDate,habitId,cueTask,scheduledTime,priority,status,cueCompletedAt,checkedInAt,recordId,createdAt,updatedAt,isCompleted,completedAt);

@override
String toString() {
  return 'DailyPlan(id: $id, planDate: $planDate, habitId: $habitId, cueTask: $cueTask, scheduledTime: $scheduledTime, priority: $priority, status: $status, cueCompletedAt: $cueCompletedAt, checkedInAt: $checkedInAt, recordId: $recordId, createdAt: $createdAt, updatedAt: $updatedAt, isCompleted: $isCompleted, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$DailyPlanCopyWith<$Res> implements $DailyPlanCopyWith<$Res> {
  factory _$DailyPlanCopyWith(_DailyPlan value, $Res Function(_DailyPlan) _then) = __$DailyPlanCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime planDate, String habitId, String cueTask, DateTime? scheduledTime, int priority, PlanCompletionStatus status, DateTime? cueCompletedAt, DateTime? checkedInAt, String? recordId, DateTime createdAt, DateTime? updatedAt,@Deprecated('Use status instead') bool isCompleted,@Deprecated('Use checkedInAt instead') DateTime? completedAt
});




}
/// @nodoc
class __$DailyPlanCopyWithImpl<$Res>
    implements _$DailyPlanCopyWith<$Res> {
  __$DailyPlanCopyWithImpl(this._self, this._then);

  final _DailyPlan _self;
  final $Res Function(_DailyPlan) _then;

/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? planDate = null,Object? habitId = null,Object? cueTask = null,Object? scheduledTime = freezed,Object? priority = null,Object? status = null,Object? cueCompletedAt = freezed,Object? checkedInAt = freezed,Object? recordId = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isCompleted = null,Object? completedAt = freezed,}) {
  return _then(_DailyPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,planDate: null == planDate ? _self.planDate : planDate // ignore: cast_nullable_to_non_nullable
as DateTime,habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,cueTask: null == cueTask ? _self.cueTask : cueTask // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanCompletionStatus,cueCompletedAt: freezed == cueCompletedAt ? _self.cueCompletedAt : cueCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
