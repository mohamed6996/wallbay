import 'package:json_annotation/json_annotation.dart';
part 'me_response.g.dart';

@JsonSerializable()
class MeResponse{
   String username;
   String first_name;
   String last_name;
   String portfolio_url;
   String bio;
   String location;
   int total_likes;
   int total_photos;
   int total_collections;
   int downloads;
   int uploads_remaining;
   String instagram_username;
   String email;
   Links links;

   MeResponse(this.username, this.first_name, this.last_name,
       this.portfolio_url, this.bio, this.location, this.total_likes,
       this.total_photos, this.total_collections, this.downloads,
       this.uploads_remaining, this.instagram_username, this.email, this.links);

   factory MeResponse.fromJson(Map<String, dynamic> json) =>
       _$MeResponseFromJson(json);


}

@JsonSerializable()
class Links {
  /**
   * self : https://api.unsplash.com/users/jimmyexample
   * html : https://unsplash.com/jimmyexample
   * photos : https://api.unsplash.com/users/jimmyexample/photos
   * likes : https://api.unsplash.com/users/jimmyexample/likes
   */
   String self;
   String html;
   String photos;
   String likes;

   Links(this.self, this.html, this.photos, this.likes);

   factory Links.fromJson(Map<String, dynamic> json) =>
       _$LinksFromJson(json);

}