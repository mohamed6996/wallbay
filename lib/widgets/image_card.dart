import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallbay/model/photo_model.dart';

class ImageCard extends StatelessWidget {
  final PhotoModel photoModel;
  final VoidCallback onFavoritePressed;

  ImageCard(this.photoModel, this.onFavoritePressed);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: photoModel.regularPhotoUrl,
            errorWidget: (context, String s, o) {
              return Icon(Icons.error);
            },
            placeholder: (context, String err) {
              return SizedBox(
                width: double.infinity,
                height: 250.0,
                child: DecoratedBox(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 0.5,
                    )),
                    decoration: BoxDecoration(
                        color: Color(int.parse(
                            "0xFF${photoModel.color.substring(1)}")))),
                //https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
                // use subString to remove the #
              );
            },
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

  Widget _circleImage(String url) {
    return Container(
        width: 35.0,
        height: 35.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover, image: new NetworkImage(url))));
  }
}

class GridItemView extends StatelessWidget {
  final PhotoModel photoModel;
  final VoidCallback onFavoritePressed;

  GridItemView(this.photoModel, this.onFavoritePressed);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: photoModel.regularPhotoUrl,
              errorWidget: (context, String s, o) {
                return Icon(Icons.error);
              },
              placeholder: (context, String err) {
                return SizedBox(
                  width: double.infinity,
                  height: 250.0,
                  child: DecoratedBox(
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 0.5,
                      )),
                      decoration: BoxDecoration(
                          color: Color(int.parse(
                              "0xFF${photoModel.color.substring(1)}")))),
                  //https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
                  // use subString to remove the #
                );
              },
            ),
          ),
        ),

        Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
                icon: photoModel.liked_by_user
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border, color: Colors.white),
                onPressed: onFavoritePressed))

      ],
    );
  }
}
