import 'package:json_annotation/json_annotation.dart';

part 'photo_response.g.dart';

class PhotoResponseList {
  List<PhotoResponse> responseList;

  PhotoResponseList({this.responseList});

  factory PhotoResponseList.fromJson(List<dynamic> json) {
    List<PhotoResponse> responses = new List<PhotoResponse>();
    responses = json.map((i) => PhotoResponse.fromJson(i)).toList();
    return new PhotoResponseList(responseList: responses);
  }
}

@JsonSerializable()
class PhotoResponse {
  String id;
  String created_at;
  String updated_at;
  int width;
  int height;
  String color;
  int likes;
  bool liked_by_user;
  PhotoUrls urls;
  PhotoLinks links;
  User user;

  PhotoResponse(
      this.id,
      this.created_at,
      this.updated_at,
      this.width,
      this.height,
      this.color,
      this.likes,
      this.liked_by_user,
      this.urls,
      this.links,
      this.user);

  factory PhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoResponseFromJson(json);
}

@JsonSerializable()
class PhotoUrls {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;

  PhotoUrls(this.raw, this.full, this.regular, this.small, this.thumb);

  factory PhotoUrls.fromJson(Map<String, dynamic> json) =>
      _$PhotoUrlsFromJson(json);
}

@JsonSerializable()
class PhotoLinks {
  String self;
  String html;
  String download;
  String download_location;

  PhotoLinks(this.self, this.html, this.download, this.download_location);

  factory PhotoLinks.fromJson(Map<String, dynamic> json) =>
      _$PhotoLinksFromJson(json);
}

@JsonSerializable()
class User {
  String id;
  String username;
  String name;
  String bio;
  String location;
  String portfolio_url;
  String twitter_username;
  String instagram_username;
  int total_likes;
  int total_photos;
  int total_collections;
  int downloads;
  int uploads_remaining;
  UserLinks links;
  ProfileImage profile_image;

  User(
      this.id,
      this.username,
      this.name,
      this.bio,
      this.location,
      this.portfolio_url,
      this.twitter_username,
      this.instagram_username,
      this.total_likes,
      this.total_photos,
      this.total_collections,
      this.downloads,
      this.uploads_remaining,
      this.links,
      this.profile_image);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonSerializable()
class UserLinks {
  String self;
  String html;
  String photos;
  String likes;
  String portfolio;
  String following;
  String followers;

  UserLinks(this.self, this.html, this.photos, this.likes, this.portfolio,
      this.following, this.followers);

  factory UserLinks.fromJson(Map<String, dynamic> json) =>
      _$UserLinksFromJson(json);
}

@JsonSerializable()
class ProfileImage {
  String small;
  String medium;
  String large;

  ProfileImage(this.small, this.medium, this.large);

  factory ProfileImage.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageFromJson(json);
}

