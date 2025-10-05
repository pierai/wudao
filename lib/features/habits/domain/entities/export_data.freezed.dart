// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportData {

 String get version;// 导出格式版本
 String get appVersion;// 应用版本
 DateTime get exportedAt;// 导出时间
 Map<String, dynamic> get exportedFrom;// 导出来源设备信息
 Map<String, dynamic> get metadata;// 元数据（统计信息）
 List<Map<String, dynamic>> get habits;// 习惯列表（JSON 格式）
 List<Map<String, dynamic>> get records;// 打卡记录列表
 List<Map<String, dynamic>> get plans;// 计划列表
 List<Map<String, dynamic>> get frontmatters;
/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDataCopyWith<ExportData> get copyWith => _$ExportDataCopyWithImpl<ExportData>(this as ExportData, _$identity);

  /// Serializes this ExportData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportData&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other.exportedFrom, exportedFrom)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.habits, habits)&&const DeepCollectionEquality().equals(other.records, records)&&const DeepCollectionEquality().equals(other.plans, plans)&&const DeepCollectionEquality().equals(other.frontmatters, frontmatters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appVersion,exportedAt,const DeepCollectionEquality().hash(exportedFrom),const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(habits),const DeepCollectionEquality().hash(records),const DeepCollectionEquality().hash(plans),const DeepCollectionEquality().hash(frontmatters));

@override
String toString() {
  return 'ExportData(version: $version, appVersion: $appVersion, exportedAt: $exportedAt, exportedFrom: $exportedFrom, metadata: $metadata, habits: $habits, records: $records, plans: $plans, frontmatters: $frontmatters)';
}


}

/// @nodoc
abstract mixin class $ExportDataCopyWith<$Res>  {
  factory $ExportDataCopyWith(ExportData value, $Res Function(ExportData) _then) = _$ExportDataCopyWithImpl;
@useResult
$Res call({
 String version, String appVersion, DateTime exportedAt, Map<String, dynamic> exportedFrom, Map<String, dynamic> metadata, List<Map<String, dynamic>> habits, List<Map<String, dynamic>> records, List<Map<String, dynamic>> plans, List<Map<String, dynamic>> frontmatters
});




}
/// @nodoc
class _$ExportDataCopyWithImpl<$Res>
    implements $ExportDataCopyWith<$Res> {
  _$ExportDataCopyWithImpl(this._self, this._then);

  final ExportData _self;
  final $Res Function(ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? appVersion = null,Object? exportedAt = null,Object? exportedFrom = null,Object? metadata = null,Object? habits = null,Object? records = null,Object? plans = null,Object? frontmatters = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exportedFrom: null == exportedFrom ? _self.exportedFrom : exportedFrom // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,habits: null == habits ? _self.habits : habits // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,frontmatters: null == frontmatters ? _self.frontmatters : frontmatters // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportData].
extension ExportDataPatterns on ExportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportData value)  $default,){
final _that = this;
switch (_that) {
case _ExportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportData value)?  $default,){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String appVersion,  DateTime exportedAt,  Map<String, dynamic> exportedFrom,  Map<String, dynamic> metadata,  List<Map<String, dynamic>> habits,  List<Map<String, dynamic>> records,  List<Map<String, dynamic>> plans,  List<Map<String, dynamic>> frontmatters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.version,_that.appVersion,_that.exportedAt,_that.exportedFrom,_that.metadata,_that.habits,_that.records,_that.plans,_that.frontmatters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String appVersion,  DateTime exportedAt,  Map<String, dynamic> exportedFrom,  Map<String, dynamic> metadata,  List<Map<String, dynamic>> habits,  List<Map<String, dynamic>> records,  List<Map<String, dynamic>> plans,  List<Map<String, dynamic>> frontmatters)  $default,) {final _that = this;
switch (_that) {
case _ExportData():
return $default(_that.version,_that.appVersion,_that.exportedAt,_that.exportedFrom,_that.metadata,_that.habits,_that.records,_that.plans,_that.frontmatters);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String appVersion,  DateTime exportedAt,  Map<String, dynamic> exportedFrom,  Map<String, dynamic> metadata,  List<Map<String, dynamic>> habits,  List<Map<String, dynamic>> records,  List<Map<String, dynamic>> plans,  List<Map<String, dynamic>> frontmatters)?  $default,) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.version,_that.appVersion,_that.exportedAt,_that.exportedFrom,_that.metadata,_that.habits,_that.records,_that.plans,_that.frontmatters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportData extends ExportData {
  const _ExportData({required this.version, required this.appVersion, required this.exportedAt, required final  Map<String, dynamic> exportedFrom, required final  Map<String, dynamic> metadata, required final  List<Map<String, dynamic>> habits, required final  List<Map<String, dynamic>> records, required final  List<Map<String, dynamic>> plans, required final  List<Map<String, dynamic>> frontmatters}): _exportedFrom = exportedFrom,_metadata = metadata,_habits = habits,_records = records,_plans = plans,_frontmatters = frontmatters,super._();
  factory _ExportData.fromJson(Map<String, dynamic> json) => _$ExportDataFromJson(json);

@override final  String version;
// 导出格式版本
@override final  String appVersion;
// 应用版本
@override final  DateTime exportedAt;
// 导出时间
 final  Map<String, dynamic> _exportedFrom;
// 导出时间
@override Map<String, dynamic> get exportedFrom {
  if (_exportedFrom is EqualUnmodifiableMapView) return _exportedFrom;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_exportedFrom);
}

// 导出来源设备信息
 final  Map<String, dynamic> _metadata;
// 导出来源设备信息
@override Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

// 元数据（统计信息）
 final  List<Map<String, dynamic>> _habits;
// 元数据（统计信息）
@override List<Map<String, dynamic>> get habits {
  if (_habits is EqualUnmodifiableListView) return _habits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_habits);
}

// 习惯列表（JSON 格式）
 final  List<Map<String, dynamic>> _records;
// 习惯列表（JSON 格式）
@override List<Map<String, dynamic>> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

// 打卡记录列表
 final  List<Map<String, dynamic>> _plans;
// 打卡记录列表
@override List<Map<String, dynamic>> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}

// 计划列表
 final  List<Map<String, dynamic>> _frontmatters;
// 计划列表
@override List<Map<String, dynamic>> get frontmatters {
  if (_frontmatters is EqualUnmodifiableListView) return _frontmatters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_frontmatters);
}


/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDataCopyWith<_ExportData> get copyWith => __$ExportDataCopyWithImpl<_ExportData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportData&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other._exportedFrom, _exportedFrom)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other._habits, _habits)&&const DeepCollectionEquality().equals(other._records, _records)&&const DeepCollectionEquality().equals(other._plans, _plans)&&const DeepCollectionEquality().equals(other._frontmatters, _frontmatters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appVersion,exportedAt,const DeepCollectionEquality().hash(_exportedFrom),const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(_habits),const DeepCollectionEquality().hash(_records),const DeepCollectionEquality().hash(_plans),const DeepCollectionEquality().hash(_frontmatters));

@override
String toString() {
  return 'ExportData(version: $version, appVersion: $appVersion, exportedAt: $exportedAt, exportedFrom: $exportedFrom, metadata: $metadata, habits: $habits, records: $records, plans: $plans, frontmatters: $frontmatters)';
}


}

/// @nodoc
abstract mixin class _$ExportDataCopyWith<$Res> implements $ExportDataCopyWith<$Res> {
  factory _$ExportDataCopyWith(_ExportData value, $Res Function(_ExportData) _then) = __$ExportDataCopyWithImpl;
@override @useResult
$Res call({
 String version, String appVersion, DateTime exportedAt, Map<String, dynamic> exportedFrom, Map<String, dynamic> metadata, List<Map<String, dynamic>> habits, List<Map<String, dynamic>> records, List<Map<String, dynamic>> plans, List<Map<String, dynamic>> frontmatters
});




}
/// @nodoc
class __$ExportDataCopyWithImpl<$Res>
    implements _$ExportDataCopyWith<$Res> {
  __$ExportDataCopyWithImpl(this._self, this._then);

  final _ExportData _self;
  final $Res Function(_ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? appVersion = null,Object? exportedAt = null,Object? exportedFrom = null,Object? metadata = null,Object? habits = null,Object? records = null,Object? plans = null,Object? frontmatters = null,}) {
  return _then(_ExportData(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exportedFrom: null == exportedFrom ? _self._exportedFrom : exportedFrom // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,habits: null == habits ? _self._habits : habits // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,frontmatters: null == frontmatters ? _self._frontmatters : frontmatters // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

// dart format on
