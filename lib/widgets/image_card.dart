import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallbay/model/photo_model.dart';

class ImageCard extends StatelessWidget {
  final PhotoModel photoModel;

  ImageCard(this.photoModel);

  @override
  Widget build(BuildContext context){
    return Card(
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: photoModel.width / photoModel.height,
            child: Hero(
              tag: photoModel.photoId,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: photoModel.regularPhotoUrl,
                errorWidget: (context, String s, o) {
                  return Icon(Icons.error);
                },
                placeholder: (context, String err) {
                  return AspectRatio(
                    aspectRatio: photoModel.width / photoModel.height,
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
                  );
                },
              ),
            ),
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

class StaggeredWidget extends StatelessWidget {
  final PhotoModel photoModel;

  StaggeredWidget(this.photoModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
          aspectRatio: photoModel.width / photoModel.height,
          child: Hero(
            tag: photoModel.photoId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: photoModel.regularPhotoUrl,
                errorWidget: (context, String s, o) {
                  return Icon(Icons.error);
                },
                placeholder: (context, String err) {
                  print(err);
                  return AspectRatio(
                    aspectRatio: photoModel.width / photoModel.height,
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
                  );
                },
              ),
            ),
          )),
    );
  }
}

class GridItemView extends StatelessWidget {
  final PhotoModel photoModel;

  GridItemView(this.photoModel);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Hero(
              tag: photoModel.photoId,
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
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
