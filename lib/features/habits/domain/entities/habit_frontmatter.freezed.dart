// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_frontmatter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HabitFrontmatter {

/// 唯一标识符
 String get id;/// 标题
 String get title;/// Markdown 内容
 String get content;/// 标签列表
 List<String> get tags;/// 创建时间
 DateTime get createdAt;/// 最后更新时间
 DateTime get updatedAt;/// 元数据（可选）
 Map<String, dynamic>? get metadata;
/// Create a copy of HabitFrontmatter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitFrontmatterCopyWith<HabitFrontmatter> get copyWith => _$HabitFrontmatterCopyWithImpl<HabitFrontmatter>(this as HabitFrontmatter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitFrontmatter&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,const DeepCollectionEquality().hash(tags),createdAt,updatedAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'HabitFrontmatter(id: $id, title: $title, content: $content, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $HabitFrontmatterCopyWith<$Res>  {
  factory $HabitFrontmatterCopyWith(HabitFrontmatter value, $Res Function(HabitFrontmatter) _then) = _$HabitFrontmatterCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content, List<String> tags, DateTime createdAt, DateTime updatedAt, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$HabitFrontmatterCopyWithImpl<$Res>
    implements $HabitFrontmatterCopyWith<$Res> {
  _$HabitFrontmatterCopyWithImpl(this._self, this._then);

  final HabitFrontmatter _self;
  final $Res Function(HabitFrontmatter) _then;

/// Create a copy of HabitFrontmatter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitFrontmatter].
extension HabitFrontmatterPatterns on HabitFrontmatter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitFrontmatter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitFrontmatter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitFrontmatter value)  $default,){
final _that = this;
switch (_that) {
case _HabitFrontmatter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitFrontmatter value)?  $default,){
final _that = this;
switch (_that) {
case _HabitFrontmatter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content,  List<String> tags,  DateTime createdAt,  DateTime updatedAt,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitFrontmatter() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.tags,_that.createdAt,_that.updatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content,  List<String> tags,  DateTime createdAt,  DateTime updatedAt,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _HabitFrontmatter():
return $default(_that.id,_that.title,_that.content,_that.tags,_that.createdAt,_that.updatedAt,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content,  List<String> tags,  DateTime createdAt,  DateTime updatedAt,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _HabitFrontmatter() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.tags,_that.createdAt,_that.updatedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc


class _HabitFrontmatter extends HabitFrontmatter {
  const _HabitFrontmatter({required this.id, required this.title, required this.content, required final  List<String> tags, required this.createdAt, required this.updatedAt, final  Map<String, dynamic>? metadata}): _tags = tags,_metadata = metadata,super._();
  

/// 唯一标识符
@override final  String id;
/// 标题
@override final  String title;
/// Markdown 内容
@override final  String content;
/// 标签列表
 final  List<String> _tags;
/// 标签列表
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// 创建时间
@override final  DateTime createdAt;
/// 最后更新时间
@override final  DateTime updatedAt;
/// 元数据（可选）
 final  Map<String, dynamic>? _metadata;
/// 元数据（可选）
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HabitFrontmatter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitFrontmatterCopyWith<_HabitFrontmatter> get copyWith => __$HabitFrontmatterCopyWithImpl<_HabitFrontmatter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitFrontmatter&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,const DeepCollectionEquality().hash(_tags),createdAt,updatedAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'HabitFrontmatter(id: $id, title: $title, content: $content, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$HabitFrontmatterCopyWith<$Res> implements $HabitFrontmatterCopyWith<$Res> {
  factory _$HabitFrontmatterCopyWith(_HabitFrontmatter value, $Res Function(_HabitFrontmatter) _then) = __$HabitFrontmatterCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content, List<String> tags, DateTime createdAt, DateTime updatedAt, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$HabitFrontmatterCopyWithImpl<$Res>
    implements _$HabitFrontmatterCopyWith<$Res> {
  __$HabitFrontmatterCopyWithImpl(this._self, this._then);

  final _HabitFrontmatter _self;
  final $Res Function(_HabitFrontmatter) _then;

/// Create a copy of HabitFrontmatter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,Object? metadata = freezed,}) {
  return _then(_HabitFrontmatter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
