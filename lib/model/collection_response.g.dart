// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionResponse _$CollectionResponseFromJson(Map<String, dynamic> json) {
  return CollectionResponse(
    json['id'] as int,
    json['title'] as String,
    json['description'] as String,
    json['published_at'] as String,
    json['curated'] as bool,
    json['total_photos'] as int,
    json['private'] as bool,
    json['share_key'] as String,
    json['cover_photo'] == null
        ? null
        : CoverPhoto.fromJson(json['cover_photo'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CollectionResponseToJson(CollectionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'published_at': instance.published_at,
      'curated': instance.curated,
      'total_photos': instance.total_photos,
      'private': instance.private,
      'share_key': instance.share_key,
      'cover_photo': instance.cover_photo,
      'user': instance.user,
    };

CoverPhoto _$CoverPhotoFromJson(Map<String, dynamic> json) {
  return CoverPhoto(
    json['id'] as String,
    (json['width'] as num)?.toDouble(),
    (json['height'] as num)?.toDouble(),
    json['color'] as String,
    json['likes'] as int,
    json['liked_by_user'] as bool,
    json['description'] as String,
    json['urls'] == null
        ? null
        : CoverPhotoUrl.fromJson(json['urls'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CoverPhotoToJson(CoverPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'color': instance.color,
      'likes': instance.likes,
      'liked_by_user': instance.liked_by_user,
      'description': instance.description,
      'urls': instance.urls,
      'user': instance.user,
    };

CoverPhotoUrl _$CoverPhotoUrlFromJson(Map<String, dynamic> json) {
  return CoverPhotoUrl(
    json['raw'] as String,
    json['full'] as String,
    json['regular'] as String,
    json['small'] as String,
    json['thumb'] as String,
  );
}

Map<String, dynamic> _$CoverPhotoUrlToJson(CoverPhotoUrl instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'full': instance.full,
      'regular': instance.regular,
      'small': instance.small,
      'thumb': instance.thumb,
    };
