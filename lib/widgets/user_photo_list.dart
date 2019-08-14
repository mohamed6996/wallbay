import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/photo_model.dart';

class UserPhotoList extends StatelessWidget {
  final List<PhotoModel> models;
  final SharedPreferences sharedPreferences;

  UserPhotoList({Key key, this.models, this.sharedPreferences})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: models.length >= 4 ? 4 : models.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, int index) {
          return userImageCard(models[index]);
        });
  }

  Widget userImageCard(PhotoModel photoModel) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: 150.0,
        height: 180.0,
        imageUrl: photoModel.regularPhotoUrl,
        errorWidget: (context, String s, o) {
          return Icon(Icons.error);
        },
        placeholder: (context, String err) {
          return SizedBox(
            width: 150.0,
            height: 180.0,
            child: DecoratedBox(
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 0.5,
                )),
                decoration: BoxDecoration(
                    color: Color(
                        int.parse("0xFF${photoModel.color.substring(1)}")))),
            //https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
            // use subString to remove the #
          );
        },
      ),
    );
  }

  Widget seeMore() {
    return Center(
      child: FlatButton(
          onPressed: () {},
          child: Text("See more"),
          padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0)),
    );
  }
}
