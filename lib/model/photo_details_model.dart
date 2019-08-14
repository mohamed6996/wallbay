import 'package:wallbay/model/photo_details_response.dart';

class PhotoDetailsModel {
  String created_at;
  int downloads;
  int likes;
  String country;
  String shareLink;
  String description;

  PhotoDetailsModel(this.created_at, this.downloads, this.likes, this.country,this.shareLink,this.description);

  PhotoDetailsModel.fromPhotoResponse(PhotoDetails response) {
    created_at = response.created_at;
    downloads = response.downloads;
    likes = response.likes;
    shareLink = response.links.html;
    description = response.description !=null ? response.description : "...";
    if (response.location != null && response.location.country != null) {
      country = response.location.country;
    } else {
      country = "...";
    }
  }
}
