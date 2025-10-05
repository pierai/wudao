// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Habit {

/// 唯一标识符
 String get id;/// 习惯名称
 String get name;/// 暗示：触发习惯的环境或情境信号（可选）
 String? get cue;/// 惯常行为：习惯性执行的动作
 String get routine;/// 原惯常行为（仅用于习惯替代类型）
 String? get oldRoutine;/// 奖赏：行为带来的满足感或收益（可选）
 String? get reward;/// 习惯类型
 HabitType get type;/// 分类（可选）
 String? get category;/// 备注说明
 String? get notes;/// 是否活跃
 bool get isActive;/// 是否为核心习惯（Keystone Habit）
/// 核心习惯能引发连锁反应，带动其他习惯的形成
 bool get isKeystone;/// 创建时间
 DateTime get createdAt;/// 最后更新时间
 DateTime get updatedAt;/// 软删除时间
 DateTime? get deletedAt;
/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitCopyWith<Habit> get copyWith => _$HabitCopyWithImpl<Habit>(this as Habit, _$identity);

  /// Serializes this Habit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Habit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cue, cue) || other.cue == cue)&&(identical(other.routine, routine) || other.routine == routine)&&(identical(other.oldRoutine, oldRoutine) || other.oldRoutine == oldRoutine)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isKeystone, isKeystone) || other.isKeystone == isKeystone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,cue,routine,oldRoutine,reward,type,category,notes,isActive,isKeystone,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'Habit(id: $id, name: $name, cue: $cue, routine: $routine, oldRoutine: $oldRoutine, reward: $reward, type: $type, category: $category, notes: $notes, isActive: $isActive, isKeystone: $isKeystone, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $HabitCopyWith<$Res>  {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) _then) = _$HabitCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? cue, String routine, String? oldRoutine, String? reward, HabitType type, String? category, String? notes, bool isActive, bool isKeystone, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$HabitCopyWithImpl<$Res>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._self, this._then);

  final Habit _self;
  final $Res Function(Habit) _then;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? cue = freezed,Object? routine = null,Object? oldRoutine = freezed,Object? reward = freezed,Object? type = null,Object? category = freezed,Object? notes = freezed,Object? isActive = null,Object? isKeystone = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cue: freezed == cue ? _self.cue : cue // ignore: cast_nullable_to_non_nullable
as String?,routine: null == routine ? _self.routine : routine // ignore: cast_nullable_to_non_nullable
as String,oldRoutine: freezed == oldRoutine ? _self.oldRoutine : oldRoutine // ignore: cast_nullable_to_non_nullable
as String?,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HabitType,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isKeystone: null == isKeystone ? _self.isKeystone : isKeystone // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Habit].
extension HabitPatterns on Habit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Habit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Habit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Habit value)  $default,){
final _that = this;
switch (_that) {
case _Habit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Habit value)?  $default,){
final _that = this;
switch (_that) {
case _Habit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? cue,  String routine,  String? oldRoutine,  String? reward,  HabitType type,  String? category,  String? notes,  bool isActive,  bool isKeystone,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that.id,_that.name,_that.cue,_that.routine,_that.oldRoutine,_that.reward,_that.type,_that.category,_that.notes,_that.isActive,_that.isKeystone,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? cue,  String routine,  String? oldRoutine,  String? reward,  HabitType type,  String? category,  String? notes,  bool isActive,  bool isKeystone,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Habit():
return $default(_that.id,_that.name,_that.cue,_that.routine,_that.oldRoutine,_that.reward,_that.type,_that.category,_that.notes,_that.isActive,_that.isKeystone,_that.createdAt,_that.updatedAt,_that.deletedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? cue,  String routine,  String? oldRoutine,  String? reward,  HabitType type,  String? category,  String? notes,  bool isActive,  bool isKeystone,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that.id,_that.name,_that.cue,_that.routine,_that.oldRoutine,_that.reward,_that.type,_that.category,_that.notes,_that.isActive,_that.isKeystone,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Habit extends Habit {
  const _Habit({required this.id, required this.name, this.cue, required this.routine, this.oldRoutine, this.reward, required this.type, this.category, this.notes, required this.isActive, this.isKeystone = false, required this.createdAt, required this.updatedAt, this.deletedAt}): super._();
  factory _Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

/// 唯一标识符
@override final  String id;
/// 习惯名称
@override final  String name;
/// 暗示：触发习惯的环境或情境信号（可选）
@override final  String? cue;
/// 惯常行为：习惯性执行的动作
@override final  String routine;
/// 原惯常行为（仅用于习惯替代类型）
@override final  String? oldRoutine;
/// 奖赏：行为带来的满足感或收益（可选）
@override final  String? reward;
/// 习惯类型
@override final  HabitType type;
/// 分类（可选）
@override final  String? category;
/// 备注说明
@override final  String? notes;
/// 是否活跃
@override final  bool isActive;
/// 是否为核心习惯（Keystone Habit）
/// 核心习惯能引发连锁反应，带动其他习惯的形成
@override@JsonKey() final  bool isKeystone;
/// 创建时间
@override final  DateTime createdAt;
/// 最后更新时间
@override final  DateTime updatedAt;
/// 软删除时间
@override final  DateTime? deletedAt;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitCopyWith<_Habit> get copyWith => __$HabitCopyWithImpl<_Habit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Habit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cue, cue) || other.cue == cue)&&(identical(other.routine, routine) || other.routine == routine)&&(identical(other.oldRoutine, oldRoutine) || other.oldRoutine == oldRoutine)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isKeystone, isKeystone) || other.isKeystone == isKeystone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,cue,routine,oldRoutine,reward,type,category,notes,isActive,isKeystone,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'Habit(id: $id, name: $name, cue: $cue, routine: $routine, oldRoutine: $oldRoutine, reward: $reward, type: $type, category: $category, notes: $notes, isActive: $isActive, isKeystone: $isKeystone, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$HabitCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$HabitCopyWith(_Habit value, $Res Function(_Habit) _then) = __$HabitCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? cue, String routine, String? oldRoutine, String? reward, HabitType type, String? category, String? notes, bool isActive, bool isKeystone, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$HabitCopyWithImpl<$Res>
    implements _$HabitCopyWith<$Res> {
  __$HabitCopyWithImpl(this._self, this._then);

  final _Habit _self;
  final $Res Function(_Habit) _then;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? cue = freezed,Object? routine = null,Object? oldRoutine = freezed,Object? reward = freezed,Object? type = null,Object? category = freezed,Object? notes = freezed,Object? isActive = null,Object? isKeystone = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_Habit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cue: freezed == cue ? _self.cue : cue // ignore: cast_nullable_to_non_nullable
as String?,routine: null == routine ? _self.routine : routine // ignore: cast_nullable_to_non_nullable
as String,oldRoutine: freezed == oldRoutine ? _self.oldRoutine : oldRoutine // ignore: cast_nullable_to_non_nullable
as String?,reward: freezed == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HabitType,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isKeystone: null == isKeystone ? _self.isKeystone : isKeystone // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
