import 'package:wallbay/model/me_response.dart';

class MeModel {
  String username;
  String likeLink;

  MeModel(this.username, this.likeLink);

  MeModel.fromMeResponse(MeResponse res)
      : username = res.username,
        likeLink = res.links.likes;
}
