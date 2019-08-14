import 'package:json_annotation/json_annotation.dart';
part 'photo_details_response.g.dart';

@JsonSerializable()
class PhotoDetails {
  String id ;
  String created_at;
  int width;
  int height;
  String color;
  int downloads;
  int likes;
  bool liked_by_user;
  String description;
  Exif exif;
  Location location;
  PhotoUrls urls;
  PhotoLinks links;
  User user;

  PhotoDetails(this.id, this.created_at, this.width, this.height, this.color,
      this.downloads, this.likes, this.liked_by_user,this.description, this.exif, this.location,
      this.urls, this.links, this.user);


  factory PhotoDetails.fromJson(Map<String, dynamic> json) =>
      _$PhotoDetailsFromJson(json);

}

@JsonSerializable()
class Exif {
  String make;
  String model;
  String exposure_time;
  String aperture;
  String focal_length;
  int iso;

  Exif(this.make, this.model, this.exposure_time, this.aperture,
      this.focal_length, this.iso);

  factory Exif.fromJson(Map<String, dynamic> json) =>
      _$ExifFromJson(json);
}

@JsonSerializable()
class Location {
  String city;
  String country;
  Position position;

  Location(this.city, this.country, this.position);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}


@JsonSerializable()
class Position {
  double latitude;
  double longitude;

  Position(this.latitude, this.longitude);

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
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
  UserLinks links;

  User(this.id, this.username, this.name, this.links);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

}


@JsonSerializable()
class UserLinks {
  String self;
  String html;
  String photos;
  String likes;

  UserLinks(this.self, this.html, this.photos, this.likes);

  factory UserLinks.fromJson(Map<String, dynamic> json) =>
      _$UserLinksFromJson(json);

}
