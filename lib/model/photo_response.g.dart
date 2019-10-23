// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoResponse _$PhotoResponseFromJson(Map<String, dynamic> json) {
  return PhotoResponse(
    json['id'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['width'] as int,
    json['height'] as int,
    json['color'] as String,
    json['likes'] as int,
    json['liked_by_user'] as bool,
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

Map<String, dynamic> _$PhotoResponseToJson(PhotoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'width': instance.width,
      'height': instance.height,
      'color': instance.color,
      'likes': instance.likes,
      'liked_by_user': instance.liked_by_user,
      'urls': instance.urls,
      'links': instance.links,
      'user': instance.user,
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
    json['bio'] as String,
    json['location'] as String,
    json['portfolio_url'] as String,
    json['twitter_username'] as String,
    json['instagram_username'] as String,
    json['total_likes'] as int,
    json['total_photos'] as int,
    json['total_collections'] as int,
    json['downloads'] as int,
    json['uploads_remaining'] as int,
    json['links'] == null
        ? null
        : UserLinks.fromJson(json['links'] as Map<String, dynamic>),
    json['profile_image'] == null
        ? null
        : ProfileImage.fromJson(json['profile_image'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'bio': instance.bio,
      'location': instance.location,
      'portfolio_url': instance.portfolio_url,
      'twitter_username': instance.twitter_username,
      'instagram_username': instance.instagram_username,
      'total_likes': instance.total_likes,
      'total_photos': instance.total_photos,
      'total_collections': instance.total_collections,
      'downloads': instance.downloads,
      'uploads_remaining': instance.uploads_remaining,
      'links': instance.links,
      'profile_image': instance.profile_image,
    };

UserLinks _$UserLinksFromJson(Map<String, dynamic> json) {
  return UserLinks(
    json['self'] as String,
    json['html'] as String,
    json['photos'] as String,
    json['likes'] as String,
    json['portfolio'] as String,
    json['following'] as String,
    json['followers'] as String,
  );
}

Map<String, dynamic> _$UserLinksToJson(UserLinks instance) => <String, dynamic>{
      'self': instance.self,
      'html': instance.html,
      'photos': instance.photos,
      'likes': instance.likes,
      'portfolio': instance.portfolio,
      'following': instance.following,
      'followers': instance.followers,
    };

ProfileImage _$ProfileImageFromJson(Map<String, dynamic> json) {
  return ProfileImage(
    json['small'] as String,
    json['medium'] as String,
    json['large'] as String,
  );
}

Map<String, dynamic> _$ProfileImageToJson(ProfileImage instance) =>
    <String, dynamic>{
      'small': instance.small,
      'medium': instance.medium,
      'large': instance.large,
    };
