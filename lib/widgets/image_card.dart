import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallbay/model/photo_model.dart';

class ImageCard extends StatelessWidget {
  final PhotoModel photoModel;
  final VoidCallback onFavoritePressed;

  ImageCard(this.photoModel, this.onFavoritePressed);

  Widget _circleImage(String url) {
    return Container(
        width: 35.0,
        height: 35.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover, image: new NetworkImage(url))));
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Column(
        children: <Widget>[
          new CachedNetworkImage(
            fit: BoxFit.fill,
            width: double.infinity,
            // height: 250.0,
            imageUrl: photoModel.regularPhotoUrl,
            placeholder: SizedBox(
              width: double.infinity,
              height: 250.0,
              child: DecoratedBox(
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 0.5,
                )),
                decoration: BoxDecoration(
                    color: Color(
                        int.parse("0xFF${photoModel.color.substring(1)}"))),
                //https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
                // use subString to remove the #
              ),
            ),
            errorWidget: new Icon(Icons.error),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        _circleImage(photoModel.mediumProfilePhotoUrl),
                        Padding(padding: EdgeInsets.only(left: 10.0)),
                        Text(
                          photoModel.name,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      IconButton(
                        icon: Icon(photoModel.liked_by_user
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: onFavoritePressed,
                      ),
                    ],
                  ),
                ),
              ])
        ],
      ),
    );
  }
}
