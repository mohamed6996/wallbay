// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) {
  return MeResponse(
    json['username'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    json['portfolio_url'] as String,
    json['bio'] as String,
    json['location'] as String,
    json['total_likes'] as int,
    json['total_photos'] as int,
    json['total_collections'] as int,
    json['downloads'] as int,
    json['uploads_remaining'] as int,
    json['instagram_username'] as String,
    json['email'] as String,
    json['links'] == null
        ? null
        : Links.fromJson(json['links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MeResponseToJson(MeResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'portfolio_url': instance.portfolio_url,
      'bio': instance.bio,
      'location': instance.location,
      'total_likes': instance.total_likes,
      'total_photos': instance.total_photos,
      'total_collections': instance.total_collections,
      'downloads': instance.downloads,
      'uploads_remaining': instance.uploads_remaining,
      'instagram_username': instance.instagram_username,
      'email': instance.email,
      'links': instance.links,
    };

Links _$LinksFromJson(Map<String, dynamic> json) {
  return Links(
    json['self'] as String,
    json['html'] as String,
    json['photos'] as String,
    json['likes'] as String,
  );
}

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'self': instance.self,
      'html': instance.html,
      'photos': instance.photos,
      'likes': instance.likes,
    };
