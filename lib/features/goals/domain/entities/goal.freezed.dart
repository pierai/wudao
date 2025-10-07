// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Goal {

/// 唯一标识符
 String get id;/// 目标标题
 String get title;/// 目标描述
 String? get description;/// 目标层级
 GoalLevel get level;/// 父目标 ID（人生目标的 parentId 为 null）
 String? get parentId;/// 层级路径（ltree 格式，如 "life.1.2025.q1"）
/// 用于高效查询子树和祖先
 String get path;/// 目标状态
 GoalStatus get status;/// 优先级（1-5，1 最高，5 最低）
 int get priority;/// 进度百分比（0-100）
 int get progress;/// 开始日期
 DateTime? get startDate;/// 截止日期
 DateTime? get deadline;/// 创建时间
 DateTime get createdAt;/// 更新时间
 DateTime? get updatedAt;/// 完成时间
 DateTime? get completedAt;/// 归档时间
 DateTime? get archivedAt;
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCopyWith<Goal> get copyWith => _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.level, level) || other.level == level)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.path, path) || other.path == path)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,level,parentId,path,status,priority,progress,startDate,deadline,createdAt,updatedAt,completedAt,archivedAt);

@override
String toString() {
  return 'Goal(id: $id, title: $title, description: $description, level: $level, parentId: $parentId, path: $path, status: $status, priority: $priority, progress: $progress, startDate: $startDate, deadline: $deadline, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res>  {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) = _$GoalCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, GoalLevel level, String? parentId, String path, GoalStatus status, int priority, int progress, DateTime? startDate, DateTime? deadline, DateTime createdAt, DateTime? updatedAt, DateTime? completedAt, DateTime? archivedAt
});




}
/// @nodoc
class _$GoalCopyWithImpl<$Res>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? level = null,Object? parentId = freezed,Object? path = null,Object? status = null,Object? priority = null,Object? progress = null,Object? startDate = freezed,Object? deadline = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? completedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as GoalLevel,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Goal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Goal value)  $default,){
final _that = this;
switch (_that) {
case _Goal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Goal value)?  $default,){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  GoalLevel level,  String? parentId,  String path,  GoalStatus status,  int priority,  int progress,  DateTime? startDate,  DateTime? deadline,  DateTime createdAt,  DateTime? updatedAt,  DateTime? completedAt,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.level,_that.parentId,_that.path,_that.status,_that.priority,_that.progress,_that.startDate,_that.deadline,_that.createdAt,_that.updatedAt,_that.completedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  GoalLevel level,  String? parentId,  String path,  GoalStatus status,  int priority,  int progress,  DateTime? startDate,  DateTime? deadline,  DateTime createdAt,  DateTime? updatedAt,  DateTime? completedAt,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Goal():
return $default(_that.id,_that.title,_that.description,_that.level,_that.parentId,_that.path,_that.status,_that.priority,_that.progress,_that.startDate,_that.deadline,_that.createdAt,_that.updatedAt,_that.completedAt,_that.archivedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  GoalLevel level,  String? parentId,  String path,  GoalStatus status,  int priority,  int progress,  DateTime? startDate,  DateTime? deadline,  DateTime createdAt,  DateTime? updatedAt,  DateTime? completedAt,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.level,_that.parentId,_that.path,_that.status,_that.priority,_that.progress,_that.startDate,_that.deadline,_that.createdAt,_that.updatedAt,_that.completedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Goal extends Goal {
  const _Goal({required this.id, required this.title, this.description, required this.level, this.parentId, required this.path, this.status = GoalStatus.active, this.priority = 3, this.progress = 0, this.startDate, this.deadline, required this.createdAt, this.updatedAt, this.completedAt, this.archivedAt}): super._();
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

/// 唯一标识符
@override final  String id;
/// 目标标题
@override final  String title;
/// 目标描述
@override final  String? description;
/// 目标层级
@override final  GoalLevel level;
/// 父目标 ID（人生目标的 parentId 为 null）
@override final  String? parentId;
/// 层级路径（ltree 格式，如 "life.1.2025.q1"）
/// 用于高效查询子树和祖先
@override final  String path;
/// 目标状态
@override@JsonKey() final  GoalStatus status;
/// 优先级（1-5，1 最高，5 最低）
@override@JsonKey() final  int priority;
/// 进度百分比（0-100）
@override@JsonKey() final  int progress;
/// 开始日期
@override final  DateTime? startDate;
/// 截止日期
@override final  DateTime? deadline;
/// 创建时间
@override final  DateTime createdAt;
/// 更新时间
@override final  DateTime? updatedAt;
/// 完成时间
@override final  DateTime? completedAt;
/// 归档时间
@override final  DateTime? archivedAt;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalCopyWith<_Goal> get copyWith => __$GoalCopyWithImpl<_Goal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.level, level) || other.level == level)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.path, path) || other.path == path)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,level,parentId,path,status,priority,progress,startDate,deadline,createdAt,updatedAt,completedAt,archivedAt);

@override
String toString() {
  return 'Goal(id: $id, title: $title, description: $description, level: $level, parentId: $parentId, path: $path, status: $status, priority: $priority, progress: $progress, startDate: $startDate, deadline: $deadline, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) = __$GoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, GoalLevel level, String? parentId, String path, GoalStatus status, int priority, int progress, DateTime? startDate, DateTime? deadline, DateTime createdAt, DateTime? updatedAt, DateTime? completedAt, DateTime? archivedAt
});




}
/// @nodoc
class __$GoalCopyWithImpl<$Res>
    implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? level = null,Object? parentId = freezed,Object? path = null,Object? status = null,Object? priority = null,Object? progress = null,Object? startDate = freezed,Object? deadline = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? completedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as GoalLevel,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GoalStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
