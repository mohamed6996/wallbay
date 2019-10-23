// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoDetails _$PhotoDetailsFromJson(Map<String, dynamic> json) {
  return PhotoDetails(
    json['id'] as String,
    json['created_at'] as String,
    json['width'] as int,
    json['height'] as int,
    json['color'] as String,
    json['downloads'] as int,
    json['likes'] as int,
    json['liked_by_user'] as bool,
    json['description'] as String,
    json['exif'] == null
        ? null
        : Exif.fromJson(json['exif'] as Map<String, dynamic>),
    json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    json['urls'] == null
        ? null
        : PhotoUrls.fromJson(json['urls'] as Map<String, dynamic>),
    json['links'] == null
        ? null
        : PhotoLinks.fromJson(json['links'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PhotoDetailsToJson(PhotoDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at,
      'width': instance.width,
      'height': instance.height,
      'color': instance.color,
      'downloads': instance.downloads,
      'likes': instance.likes,
      'liked_by_user': instance.liked_by_user,
      'description': instance.description,
      'exif': instance.exif,
      'location': instance.location,
      'urls': instance.urls,
      'links': instance.links,
      'user': instance.user,
    };

Exif _$ExifFromJson(Map<String, dynamic> json) {
  return Exif(
    json['make'] as String,
    json['model'] as String,
    json['exposure_time'] as String,
    json['aperture'] as String,
    json['focal_length'] as String,
    json['iso'] as int,
  );
}

Map<String, dynamic> _$ExifToJson(Exif instance) => <String, dynamic>{
      'make': instance.make,
      'model': instance.model,
      'exposure_time': instance.exposure_time,
      'aperture': instance.aperture,
      'focal_length': instance.focal_length,
      'iso': instance.iso,
    };

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['city'] as String,
    json['country'] as String,
    json['position'] == null
        ? null
        : Position.fromJson(json['position'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'position': instance.position,
    };

Position _$PositionFromJson(Map<String, dynamic> json) {
  return Position(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

PhotoUrls _$PhotoUrlsFromJson(Map<String, dynamic> json) {
  return PhotoUrls(
    json['raw'] as String,
    json['full'] as String,
    json['regular'] as String,
    json['small'] as String,
    json['thumb'] as String,
  );
}

Map<String, dynamic> _$PhotoUrlsToJson(PhotoUrls instance) => <String, dynamic>{
      'raw': instance.raw,
      'full': instance.full,
      'regular': instance.regular,
      'small': instance.small,
      'thumb': instance.thumb,
    };

PhotoLinks _$PhotoLinksFromJson(Map<String, dynamic> json) {
  return PhotoLinks(
    json['self'] as String,
    json['html'] as String,
    json['download'] as String,
    json['download_location'] as String,
  );
}

Map<String, dynamic> _$PhotoLinksToJson(PhotoLinks instance) =>
    <String, dynamic>{
      'self': instance.self,
      'html': instance.html,
      'download': instance.download,
      'download_location': instance.download_location,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as String,
    json['username'] as String,
    json['name'] as String,
    json['links'] == null
        ? null
        : UserLinks.fromJson(json['links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'links': instance.links,
    };

UserLinks _$UserLinksFromJson(Map<String, dynamic> json) {
  return UserLinks(
    json['self'] as String,
    json['html'] as String,
    json['photos'] as String,
    json['likes'] as String,
  );
}

Map<String, dynamic> _$UserLinksToJson(UserLinks instance) => <String, dynamic>{
      'self': instance.self,
      'html': instance.html,
      'photos': instance.photos,
      'likes': instance.likes,
    };
