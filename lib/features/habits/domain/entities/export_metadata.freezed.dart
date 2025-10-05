// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportMetadata {

 String get version;// 导出格式版本，如 "1.0.0"
 String get appVersion;// 应用版本，如 "0.1.0"
 DateTime get exportedAt;// 导出时间
 DeviceInfo get exportedFrom;// 导出来源设备
 int get totalHabits;// 习惯总数
 int get totalRecords;// 打卡记录总数
 int get totalPlans;// 计划总数
 int get totalFrontmatters;
/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportMetadataCopyWith<ExportMetadata> get copyWith => _$ExportMetadataCopyWithImpl<ExportMetadata>(this as ExportMetadata, _$identity);

  /// Serializes this ExportMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportMetadata&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.exportedFrom, exportedFrom) || other.exportedFrom == exportedFrom)&&(identical(other.totalHabits, totalHabits) || other.totalHabits == totalHabits)&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.totalPlans, totalPlans) || other.totalPlans == totalPlans)&&(identical(other.totalFrontmatters, totalFrontmatters) || other.totalFrontmatters == totalFrontmatters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appVersion,exportedAt,exportedFrom,totalHabits,totalRecords,totalPlans,totalFrontmatters);

@override
String toString() {
  return 'ExportMetadata(version: $version, appVersion: $appVersion, exportedAt: $exportedAt, exportedFrom: $exportedFrom, totalHabits: $totalHabits, totalRecords: $totalRecords, totalPlans: $totalPlans, totalFrontmatters: $totalFrontmatters)';
}


}

/// @nodoc
abstract mixin class $ExportMetadataCopyWith<$Res>  {
  factory $ExportMetadataCopyWith(ExportMetadata value, $Res Function(ExportMetadata) _then) = _$ExportMetadataCopyWithImpl;
@useResult
$Res call({
 String version, String appVersion, DateTime exportedAt, DeviceInfo exportedFrom, int totalHabits, int totalRecords, int totalPlans, int totalFrontmatters
});


$DeviceInfoCopyWith<$Res> get exportedFrom;

}
/// @nodoc
class _$ExportMetadataCopyWithImpl<$Res>
    implements $ExportMetadataCopyWith<$Res> {
  _$ExportMetadataCopyWithImpl(this._self, this._then);

  final ExportMetadata _self;
  final $Res Function(ExportMetadata) _then;

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? appVersion = null,Object? exportedAt = null,Object? exportedFrom = null,Object? totalHabits = null,Object? totalRecords = null,Object? totalPlans = null,Object? totalFrontmatters = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exportedFrom: null == exportedFrom ? _self.exportedFrom : exportedFrom // ignore: cast_nullable_to_non_nullable
as DeviceInfo,totalHabits: null == totalHabits ? _self.totalHabits : totalHabits // ignore: cast_nullable_to_non_nullable
as int,totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,totalPlans: null == totalPlans ? _self.totalPlans : totalPlans // ignore: cast_nullable_to_non_nullable
as int,totalFrontmatters: null == totalFrontmatters ? _self.totalFrontmatters : totalFrontmatters // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get exportedFrom {
  
  return $DeviceInfoCopyWith<$Res>(_self.exportedFrom, (value) {
    return _then(_self.copyWith(exportedFrom: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExportMetadata].
extension ExportMetadataPatterns on ExportMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ExportMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String appVersion,  DateTime exportedAt,  DeviceInfo exportedFrom,  int totalHabits,  int totalRecords,  int totalPlans,  int totalFrontmatters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
return $default(_that.version,_that.appVersion,_that.exportedAt,_that.exportedFrom,_that.totalHabits,_that.totalRecords,_that.totalPlans,_that.totalFrontmatters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String appVersion,  DateTime exportedAt,  DeviceInfo exportedFrom,  int totalHabits,  int totalRecords,  int totalPlans,  int totalFrontmatters)  $default,) {final _that = this;
switch (_that) {
case _ExportMetadata():
return $default(_that.version,_that.appVersion,_that.exportedAt,_that.exportedFrom,_that.totalHabits,_that.totalRecords,_that.totalPlans,_that.totalFrontmatters);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String appVersion,  DateTime exportedAt,  DeviceInfo exportedFrom,  int totalHabits,  int totalRecords,  int totalPlans,  int totalFrontmatters)?  $default,) {final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
return $default(_that.version,_that.appVersion,_that.exportedAt,_that.exportedFrom,_that.totalHabits,_that.totalRecords,_that.totalPlans,_that.totalFrontmatters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportMetadata extends ExportMetadata {
  const _ExportMetadata({required this.version, required this.appVersion, required this.exportedAt, required this.exportedFrom, required this.totalHabits, required this.totalRecords, required this.totalPlans, required this.totalFrontmatters}): super._();
  factory _ExportMetadata.fromJson(Map<String, dynamic> json) => _$ExportMetadataFromJson(json);

@override final  String version;
// 导出格式版本，如 "1.0.0"
@override final  String appVersion;
// 应用版本，如 "0.1.0"
@override final  DateTime exportedAt;
// 导出时间
@override final  DeviceInfo exportedFrom;
// 导出来源设备
@override final  int totalHabits;
// 习惯总数
@override final  int totalRecords;
// 打卡记录总数
@override final  int totalPlans;
// 计划总数
@override final  int totalFrontmatters;

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportMetadataCopyWith<_ExportMetadata> get copyWith => __$ExportMetadataCopyWithImpl<_ExportMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportMetadata&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.exportedFrom, exportedFrom) || other.exportedFrom == exportedFrom)&&(identical(other.totalHabits, totalHabits) || other.totalHabits == totalHabits)&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.totalPlans, totalPlans) || other.totalPlans == totalPlans)&&(identical(other.totalFrontmatters, totalFrontmatters) || other.totalFrontmatters == totalFrontmatters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appVersion,exportedAt,exportedFrom,totalHabits,totalRecords,totalPlans,totalFrontmatters);

@override
String toString() {
  return 'ExportMetadata(version: $version, appVersion: $appVersion, exportedAt: $exportedAt, exportedFrom: $exportedFrom, totalHabits: $totalHabits, totalRecords: $totalRecords, totalPlans: $totalPlans, totalFrontmatters: $totalFrontmatters)';
}


}

/// @nodoc
abstract mixin class _$ExportMetadataCopyWith<$Res> implements $ExportMetadataCopyWith<$Res> {
  factory _$ExportMetadataCopyWith(_ExportMetadata value, $Res Function(_ExportMetadata) _then) = __$ExportMetadataCopyWithImpl;
@override @useResult
$Res call({
 String version, String appVersion, DateTime exportedAt, DeviceInfo exportedFrom, int totalHabits, int totalRecords, int totalPlans, int totalFrontmatters
});


@override $DeviceInfoCopyWith<$Res> get exportedFrom;

}
/// @nodoc
class __$ExportMetadataCopyWithImpl<$Res>
    implements _$ExportMetadataCopyWith<$Res> {
  __$ExportMetadataCopyWithImpl(this._self, this._then);

  final _ExportMetadata _self;
  final $Res Function(_ExportMetadata) _then;

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? appVersion = null,Object? exportedAt = null,Object? exportedFrom = null,Object? totalHabits = null,Object? totalRecords = null,Object? totalPlans = null,Object? totalFrontmatters = null,}) {
  return _then(_ExportMetadata(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exportedFrom: null == exportedFrom ? _self.exportedFrom : exportedFrom // ignore: cast_nullable_to_non_nullable
as DeviceInfo,totalHabits: null == totalHabits ? _self.totalHabits : totalHabits // ignore: cast_nullable_to_non_nullable
as int,totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,totalPlans: null == totalPlans ? _self.totalPlans : totalPlans // ignore: cast_nullable_to_non_nullable
as int,totalFrontmatters: null == totalFrontmatters ? _self.totalFrontmatters : totalFrontmatters // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get exportedFrom {
  
  return $DeviceInfoCopyWith<$Res>(_self.exportedFrom, (value) {
    return _then(_self.copyWith(exportedFrom: value));
  });
}
}

// dart format on
