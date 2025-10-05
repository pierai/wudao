// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conflict_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConflictInfo {

/// 冲突类型
 ConflictType get type;/// 冲突 ID
 String get conflictId;/// 当前设备数据（JSON）
 Map<String, dynamic> get currentData;/// 导入文件数据（JSON）
 Map<String, dynamic> get importData;/// 冲突原因描述
 String get reason;/// 推荐的合并方式（基于更新时间）
 String? get recommendedAction;
/// Create a copy of ConflictInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictInfoCopyWith<ConflictInfo> get copyWith => _$ConflictInfoCopyWithImpl<ConflictInfo>(this as ConflictInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.conflictId, conflictId) || other.conflictId == conflictId)&&const DeepCollectionEquality().equals(other.currentData, currentData)&&const DeepCollectionEquality().equals(other.importData, importData)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.recommendedAction, recommendedAction) || other.recommendedAction == recommendedAction));
}


@override
int get hashCode => Object.hash(runtimeType,type,conflictId,const DeepCollectionEquality().hash(currentData),const DeepCollectionEquality().hash(importData),reason,recommendedAction);

@override
String toString() {
  return 'ConflictInfo(type: $type, conflictId: $conflictId, currentData: $currentData, importData: $importData, reason: $reason, recommendedAction: $recommendedAction)';
}


}

/// @nodoc
abstract mixin class $ConflictInfoCopyWith<$Res>  {
  factory $ConflictInfoCopyWith(ConflictInfo value, $Res Function(ConflictInfo) _then) = _$ConflictInfoCopyWithImpl;
@useResult
$Res call({
 ConflictType type, String conflictId, Map<String, dynamic> currentData, Map<String, dynamic> importData, String reason, String? recommendedAction
});




}
/// @nodoc
class _$ConflictInfoCopyWithImpl<$Res>
    implements $ConflictInfoCopyWith<$Res> {
  _$ConflictInfoCopyWithImpl(this._self, this._then);

  final ConflictInfo _self;
  final $Res Function(ConflictInfo) _then;

/// Create a copy of ConflictInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? conflictId = null,Object? currentData = null,Object? importData = null,Object? reason = null,Object? recommendedAction = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConflictType,conflictId: null == conflictId ? _self.conflictId : conflictId // ignore: cast_nullable_to_non_nullable
as String,currentData: null == currentData ? _self.currentData : currentData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,importData: null == importData ? _self.importData : importData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,recommendedAction: freezed == recommendedAction ? _self.recommendedAction : recommendedAction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConflictInfo].
extension ConflictInfoPatterns on ConflictInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConflictInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConflictInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConflictInfo value)  $default,){
final _that = this;
switch (_that) {
case _ConflictInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConflictInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ConflictInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConflictType type,  String conflictId,  Map<String, dynamic> currentData,  Map<String, dynamic> importData,  String reason,  String? recommendedAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConflictInfo() when $default != null:
return $default(_that.type,_that.conflictId,_that.currentData,_that.importData,_that.reason,_that.recommendedAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConflictType type,  String conflictId,  Map<String, dynamic> currentData,  Map<String, dynamic> importData,  String reason,  String? recommendedAction)  $default,) {final _that = this;
switch (_that) {
case _ConflictInfo():
return $default(_that.type,_that.conflictId,_that.currentData,_that.importData,_that.reason,_that.recommendedAction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConflictType type,  String conflictId,  Map<String, dynamic> currentData,  Map<String, dynamic> importData,  String reason,  String? recommendedAction)?  $default,) {final _that = this;
switch (_that) {
case _ConflictInfo() when $default != null:
return $default(_that.type,_that.conflictId,_that.currentData,_that.importData,_that.reason,_that.recommendedAction);case _:
  return null;

}
}

}

/// @nodoc


class _ConflictInfo extends ConflictInfo {
  const _ConflictInfo({required this.type, required this.conflictId, required final  Map<String, dynamic> currentData, required final  Map<String, dynamic> importData, required this.reason, this.recommendedAction}): _currentData = currentData,_importData = importData,super._();
  

/// 冲突类型
@override final  ConflictType type;
/// 冲突 ID
@override final  String conflictId;
/// 当前设备数据（JSON）
 final  Map<String, dynamic> _currentData;
/// 当前设备数据（JSON）
@override Map<String, dynamic> get currentData {
  if (_currentData is EqualUnmodifiableMapView) return _currentData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_currentData);
}

/// 导入文件数据（JSON）
 final  Map<String, dynamic> _importData;
/// 导入文件数据（JSON）
@override Map<String, dynamic> get importData {
  if (_importData is EqualUnmodifiableMapView) return _importData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_importData);
}

/// 冲突原因描述
@override final  String reason;
/// 推荐的合并方式（基于更新时间）
@override final  String? recommendedAction;

/// Create a copy of ConflictInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictInfoCopyWith<_ConflictInfo> get copyWith => __$ConflictInfoCopyWithImpl<_ConflictInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.conflictId, conflictId) || other.conflictId == conflictId)&&const DeepCollectionEquality().equals(other._currentData, _currentData)&&const DeepCollectionEquality().equals(other._importData, _importData)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.recommendedAction, recommendedAction) || other.recommendedAction == recommendedAction));
}


@override
int get hashCode => Object.hash(runtimeType,type,conflictId,const DeepCollectionEquality().hash(_currentData),const DeepCollectionEquality().hash(_importData),reason,recommendedAction);

@override
String toString() {
  return 'ConflictInfo(type: $type, conflictId: $conflictId, currentData: $currentData, importData: $importData, reason: $reason, recommendedAction: $recommendedAction)';
}


}

/// @nodoc
abstract mixin class _$ConflictInfoCopyWith<$Res> implements $ConflictInfoCopyWith<$Res> {
  factory _$ConflictInfoCopyWith(_ConflictInfo value, $Res Function(_ConflictInfo) _then) = __$ConflictInfoCopyWithImpl;
@override @useResult
$Res call({
 ConflictType type, String conflictId, Map<String, dynamic> currentData, Map<String, dynamic> importData, String reason, String? recommendedAction
});




}
/// @nodoc
class __$ConflictInfoCopyWithImpl<$Res>
    implements _$ConflictInfoCopyWith<$Res> {
  __$ConflictInfoCopyWithImpl(this._self, this._then);

  final _ConflictInfo _self;
  final $Res Function(_ConflictInfo) _then;

/// Create a copy of ConflictInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? conflictId = null,Object? currentData = null,Object? importData = null,Object? reason = null,Object? recommendedAction = freezed,}) {
  return _then(_ConflictInfo(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConflictType,conflictId: null == conflictId ? _self.conflictId : conflictId // ignore: cast_nullable_to_non_nullable
as String,currentData: null == currentData ? _self._currentData : currentData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,importData: null == importData ? _self._importData : importData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,recommendedAction: freezed == recommendedAction ? _self.recommendedAction : recommendedAction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
