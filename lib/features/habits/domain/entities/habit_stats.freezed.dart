// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HabitStats {

/// 当前连续天数
 int get currentStreak;/// 最佳连续记录
 int get bestStreak;/// 总执行次数
 int get totalExecutions;/// 本周执行次数
 int get thisWeekExecutions;/// 本月执行次数
 int get thisMonthExecutions;/// 完成率（0.0 - 1.0）
 double get completionRate;/// 平均质量评分（1-5）
 double? get averageQuality;/// 最后打卡时间
 DateTime? get lastExecutedAt;/// 第一次打卡时间
 DateTime? get firstExecutedAt;
/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitStatsCopyWith<HabitStats> get copyWith => _$HabitStatsCopyWithImpl<HabitStats>(this as HabitStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.totalExecutions, totalExecutions) || other.totalExecutions == totalExecutions)&&(identical(other.thisWeekExecutions, thisWeekExecutions) || other.thisWeekExecutions == thisWeekExecutions)&&(identical(other.thisMonthExecutions, thisMonthExecutions) || other.thisMonthExecutions == thisMonthExecutions)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.averageQuality, averageQuality) || other.averageQuality == averageQuality)&&(identical(other.lastExecutedAt, lastExecutedAt) || other.lastExecutedAt == lastExecutedAt)&&(identical(other.firstExecutedAt, firstExecutedAt) || other.firstExecutedAt == firstExecutedAt));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,totalExecutions,thisWeekExecutions,thisMonthExecutions,completionRate,averageQuality,lastExecutedAt,firstExecutedAt);

@override
String toString() {
  return 'HabitStats(currentStreak: $currentStreak, bestStreak: $bestStreak, totalExecutions: $totalExecutions, thisWeekExecutions: $thisWeekExecutions, thisMonthExecutions: $thisMonthExecutions, completionRate: $completionRate, averageQuality: $averageQuality, lastExecutedAt: $lastExecutedAt, firstExecutedAt: $firstExecutedAt)';
}


}

/// @nodoc
abstract mixin class $HabitStatsCopyWith<$Res>  {
  factory $HabitStatsCopyWith(HabitStats value, $Res Function(HabitStats) _then) = _$HabitStatsCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int bestStreak, int totalExecutions, int thisWeekExecutions, int thisMonthExecutions, double completionRate, double? averageQuality, DateTime? lastExecutedAt, DateTime? firstExecutedAt
});




}
/// @nodoc
class _$HabitStatsCopyWithImpl<$Res>
    implements $HabitStatsCopyWith<$Res> {
  _$HabitStatsCopyWithImpl(this._self, this._then);

  final HabitStats _self;
  final $Res Function(HabitStats) _then;

/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? totalExecutions = null,Object? thisWeekExecutions = null,Object? thisMonthExecutions = null,Object? completionRate = null,Object? averageQuality = freezed,Object? lastExecutedAt = freezed,Object? firstExecutedAt = freezed,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,totalExecutions: null == totalExecutions ? _self.totalExecutions : totalExecutions // ignore: cast_nullable_to_non_nullable
as int,thisWeekExecutions: null == thisWeekExecutions ? _self.thisWeekExecutions : thisWeekExecutions // ignore: cast_nullable_to_non_nullable
as int,thisMonthExecutions: null == thisMonthExecutions ? _self.thisMonthExecutions : thisMonthExecutions // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,averageQuality: freezed == averageQuality ? _self.averageQuality : averageQuality // ignore: cast_nullable_to_non_nullable
as double?,lastExecutedAt: freezed == lastExecutedAt ? _self.lastExecutedAt : lastExecutedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firstExecutedAt: freezed == firstExecutedAt ? _self.firstExecutedAt : firstExecutedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitStats].
extension HabitStatsPatterns on HabitStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitStats value)  $default,){
final _that = this;
switch (_that) {
case _HabitStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitStats value)?  $default,){
final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  int totalExecutions,  int thisWeekExecutions,  int thisMonthExecutions,  double completionRate,  double? averageQuality,  DateTime? lastExecutedAt,  DateTime? firstExecutedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.totalExecutions,_that.thisWeekExecutions,_that.thisMonthExecutions,_that.completionRate,_that.averageQuality,_that.lastExecutedAt,_that.firstExecutedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  int totalExecutions,  int thisWeekExecutions,  int thisMonthExecutions,  double completionRate,  double? averageQuality,  DateTime? lastExecutedAt,  DateTime? firstExecutedAt)  $default,) {final _that = this;
switch (_that) {
case _HabitStats():
return $default(_that.currentStreak,_that.bestStreak,_that.totalExecutions,_that.thisWeekExecutions,_that.thisMonthExecutions,_that.completionRate,_that.averageQuality,_that.lastExecutedAt,_that.firstExecutedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int bestStreak,  int totalExecutions,  int thisWeekExecutions,  int thisMonthExecutions,  double completionRate,  double? averageQuality,  DateTime? lastExecutedAt,  DateTime? firstExecutedAt)?  $default,) {final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.totalExecutions,_that.thisWeekExecutions,_that.thisMonthExecutions,_that.completionRate,_that.averageQuality,_that.lastExecutedAt,_that.firstExecutedAt);case _:
  return null;

}
}

}

/// @nodoc


class _HabitStats extends HabitStats {
  const _HabitStats({required this.currentStreak, required this.bestStreak, required this.totalExecutions, required this.thisWeekExecutions, required this.thisMonthExecutions, required this.completionRate, this.averageQuality, this.lastExecutedAt, this.firstExecutedAt}): super._();
  

/// 当前连续天数
@override final  int currentStreak;
/// 最佳连续记录
@override final  int bestStreak;
/// 总执行次数
@override final  int totalExecutions;
/// 本周执行次数
@override final  int thisWeekExecutions;
/// 本月执行次数
@override final  int thisMonthExecutions;
/// 完成率（0.0 - 1.0）
@override final  double completionRate;
/// 平均质量评分（1-5）
@override final  double? averageQuality;
/// 最后打卡时间
@override final  DateTime? lastExecutedAt;
/// 第一次打卡时间
@override final  DateTime? firstExecutedAt;

/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitStatsCopyWith<_HabitStats> get copyWith => __$HabitStatsCopyWithImpl<_HabitStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.totalExecutions, totalExecutions) || other.totalExecutions == totalExecutions)&&(identical(other.thisWeekExecutions, thisWeekExecutions) || other.thisWeekExecutions == thisWeekExecutions)&&(identical(other.thisMonthExecutions, thisMonthExecutions) || other.thisMonthExecutions == thisMonthExecutions)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.averageQuality, averageQuality) || other.averageQuality == averageQuality)&&(identical(other.lastExecutedAt, lastExecutedAt) || other.lastExecutedAt == lastExecutedAt)&&(identical(other.firstExecutedAt, firstExecutedAt) || other.firstExecutedAt == firstExecutedAt));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,totalExecutions,thisWeekExecutions,thisMonthExecutions,completionRate,averageQuality,lastExecutedAt,firstExecutedAt);

@override
String toString() {
  return 'HabitStats(currentStreak: $currentStreak, bestStreak: $bestStreak, totalExecutions: $totalExecutions, thisWeekExecutions: $thisWeekExecutions, thisMonthExecutions: $thisMonthExecutions, completionRate: $completionRate, averageQuality: $averageQuality, lastExecutedAt: $lastExecutedAt, firstExecutedAt: $firstExecutedAt)';
}


}

/// @nodoc
abstract mixin class _$HabitStatsCopyWith<$Res> implements $HabitStatsCopyWith<$Res> {
  factory _$HabitStatsCopyWith(_HabitStats value, $Res Function(_HabitStats) _then) = __$HabitStatsCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int bestStreak, int totalExecutions, int thisWeekExecutions, int thisMonthExecutions, double completionRate, double? averageQuality, DateTime? lastExecutedAt, DateTime? firstExecutedAt
});




}
/// @nodoc
class __$HabitStatsCopyWithImpl<$Res>
    implements _$HabitStatsCopyWith<$Res> {
  __$HabitStatsCopyWithImpl(this._self, this._then);

  final _HabitStats _self;
  final $Res Function(_HabitStats) _then;

/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? totalExecutions = null,Object? thisWeekExecutions = null,Object? thisMonthExecutions = null,Object? completionRate = null,Object? averageQuality = freezed,Object? lastExecutedAt = freezed,Object? firstExecutedAt = freezed,}) {
  return _then(_HabitStats(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,totalExecutions: null == totalExecutions ? _self.totalExecutions : totalExecutions // ignore: cast_nullable_to_non_nullable
as int,thisWeekExecutions: null == thisWeekExecutions ? _self.thisWeekExecutions : thisWeekExecutions // ignore: cast_nullable_to_non_nullable
as int,thisMonthExecutions: null == thisMonthExecutions ? _self.thisMonthExecutions : thisMonthExecutions // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,averageQuality: freezed == averageQuality ? _self.averageQuality : averageQuality // ignore: cast_nullable_to_non_nullable
as double?,lastExecutedAt: freezed == lastExecutedAt ? _self.lastExecutedAt : lastExecutedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firstExecutedAt: freezed == firstExecutedAt ? _self.firstExecutedAt : firstExecutedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
