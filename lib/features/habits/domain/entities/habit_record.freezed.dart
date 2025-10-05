// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitRecord {

/// 唯一标识符
 String get id;/// 关联的习惯 ID
 String get habitId;/// 执行时间（打卡时间）
 DateTime get executedAt;/// 执行质量评分（1-5 星，可选）
 int? get quality;/// 执行笔记（可选）
 String? get notes;/// 是否为补打卡
 bool get isBackfilled;/// 创建时间
 DateTime get createdAt;
/// Create a copy of HabitRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitRecordCopyWith<HabitRecord> get copyWith => _$HabitRecordCopyWithImpl<HabitRecord>(this as HabitRecord, _$identity);

  /// Serializes this HabitRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isBackfilled, isBackfilled) || other.isBackfilled == isBackfilled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,habitId,executedAt,quality,notes,isBackfilled,createdAt);

@override
String toString() {
  return 'HabitRecord(id: $id, habitId: $habitId, executedAt: $executedAt, quality: $quality, notes: $notes, isBackfilled: $isBackfilled, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $HabitRecordCopyWith<$Res>  {
  factory $HabitRecordCopyWith(HabitRecord value, $Res Function(HabitRecord) _then) = _$HabitRecordCopyWithImpl;
@useResult
$Res call({
 String id, String habitId, DateTime executedAt, int? quality, String? notes, bool isBackfilled, DateTime createdAt
});




}
/// @nodoc
class _$HabitRecordCopyWithImpl<$Res>
    implements $HabitRecordCopyWith<$Res> {
  _$HabitRecordCopyWithImpl(this._self, this._then);

  final HabitRecord _self;
  final $Res Function(HabitRecord) _then;

/// Create a copy of HabitRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? habitId = null,Object? executedAt = null,Object? quality = freezed,Object? notes = freezed,Object? isBackfilled = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,executedAt: null == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isBackfilled: null == isBackfilled ? _self.isBackfilled : isBackfilled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitRecord].
extension HabitRecordPatterns on HabitRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitRecord value)  $default,){
final _that = this;
switch (_that) {
case _HabitRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HabitRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String habitId,  DateTime executedAt,  int? quality,  String? notes,  bool isBackfilled,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitRecord() when $default != null:
return $default(_that.id,_that.habitId,_that.executedAt,_that.quality,_that.notes,_that.isBackfilled,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String habitId,  DateTime executedAt,  int? quality,  String? notes,  bool isBackfilled,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _HabitRecord():
return $default(_that.id,_that.habitId,_that.executedAt,_that.quality,_that.notes,_that.isBackfilled,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String habitId,  DateTime executedAt,  int? quality,  String? notes,  bool isBackfilled,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _HabitRecord() when $default != null:
return $default(_that.id,_that.habitId,_that.executedAt,_that.quality,_that.notes,_that.isBackfilled,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitRecord extends HabitRecord {
  const _HabitRecord({required this.id, required this.habitId, required this.executedAt, this.quality, this.notes, required this.isBackfilled, required this.createdAt}): super._();
  factory _HabitRecord.fromJson(Map<String, dynamic> json) => _$HabitRecordFromJson(json);

/// 唯一标识符
@override final  String id;
/// 关联的习惯 ID
@override final  String habitId;
/// 执行时间（打卡时间）
@override final  DateTime executedAt;
/// 执行质量评分（1-5 星，可选）
@override final  int? quality;
/// 执行笔记（可选）
@override final  String? notes;
/// 是否为补打卡
@override final  bool isBackfilled;
/// 创建时间
@override final  DateTime createdAt;

/// Create a copy of HabitRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitRecordCopyWith<_HabitRecord> get copyWith => __$HabitRecordCopyWithImpl<_HabitRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isBackfilled, isBackfilled) || other.isBackfilled == isBackfilled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,habitId,executedAt,quality,notes,isBackfilled,createdAt);

@override
String toString() {
  return 'HabitRecord(id: $id, habitId: $habitId, executedAt: $executedAt, quality: $quality, notes: $notes, isBackfilled: $isBackfilled, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HabitRecordCopyWith<$Res> implements $HabitRecordCopyWith<$Res> {
  factory _$HabitRecordCopyWith(_HabitRecord value, $Res Function(_HabitRecord) _then) = __$HabitRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String habitId, DateTime executedAt, int? quality, String? notes, bool isBackfilled, DateTime createdAt
});




}
/// @nodoc
class __$HabitRecordCopyWithImpl<$Res>
    implements _$HabitRecordCopyWith<$Res> {
  __$HabitRecordCopyWithImpl(this._self, this._then);

  final _HabitRecord _self;
  final $Res Function(_HabitRecord) _then;

/// Create a copy of HabitRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? habitId = null,Object? executedAt = null,Object? quality = freezed,Object? notes = freezed,Object? isBackfilled = null,Object? createdAt = null,}) {
  return _then(_HabitRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,executedAt: null == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isBackfilled: null == isBackfilled ? _self.isBackfilled : isBackfilled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
