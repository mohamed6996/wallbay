import 'package:json_annotation/json_annotation.dart';
import 'package:wallbay/model/photo_response.dart';

part 'photo_search_response.g.dart';

@JsonSerializable()
class PhotoSearchResponse {
  int total;
  int total_pages;

  List<PhotoResponse> results;

  PhotoSearchResponse(this.total, this.total_pages, this.results);

  factory PhotoSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoSearchResponseFromJson(json);
}

//@JsonSerializable()
//class PhotoResponse {
//  String id;
//  String created_at;
//  int width;
//  int height;
//  String color;
//  int likes;
//  bool liked_by_user;
//  String description;
//  User user;
//  PhotoUrls urls;
//  PhotoLinks links;
//
//  PhotoResponse(
//      this.id,
//      this.created_at,
//      this.width,
//      this.height,
//      this.color,
//      this.likes,
//      this.liked_by_user,
//      this.description,
//      this.user,
//      this.urls,
//      this.links);
//
//  factory PhotoResponse.fromJson(Map<String, dynamic> json) => _$PhotoResponseFromJson(json);
//}
//
//@JsonSerializable()
//class User {
//  String id;
//  String username;
//  String name;
//  String portfolio_url;
//  String twitter_username;
//  String instagram_username;
//  UserLinks links;
//  ProfileImage profile_image;
//
//  User(
//      this.id,
//      this.username,
//      this.name,
//      this.portfolio_url,
//      this.twitter_username,
//      this.instagram_username,
//      this.links,
//      this.profile_image);
//
//  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//}
//
//@JsonSerializable()
//class ProfileImage {
//  String small;
//  String medium;
//  String large;
//
//  ProfileImage(this.small, this.medium, this.large);
//
//  factory ProfileImage.fromJson(Map<String, dynamic> json) =>
//      _$ProfileImageFromJson(json);
//}
//
//@JsonSerializable()
//class UserLinks {
//  String self;
//  String html;
//  String photos;
//  String likes;
//
//  UserLinks(this.self, this.html, this.photos, this.likes);
//
//  factory UserLinks.fromJson(Map<String, dynamic> json) =>
//      _$UserLinksFromJson(json);
//}
//
//@JsonSerializable()
//class PhotoUrls {
//  String raw;
//  String full;
//  String regular;
//  String small;
//  String thumb;
//
//  PhotoUrls(this.raw, this.full, this.regular, this.small, this.thumb);
//
//  factory PhotoUrls.fromJson(Map<String, dynamic> json) =>
//      _$PhotoUrlsFromJson(json);
//}
//
//@JsonSerializable()
//class PhotoLinks {
//  String self;
//  String html;
//  String download;
//
//  PhotoLinks(this.self, this.html, this.download);
//
//  factory PhotoLinks.fromJson(Map<String, dynamic> json) =>
//      _$PhotoLinksFromJson(json);
//}
