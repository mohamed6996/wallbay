import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallbay/model/collection_model.dart';

class CollectionCard extends StatelessWidget {
  final CollectionModel collectionModel;

  CollectionCard(this.collectionModel);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // using stack make card loses its border radius, and setting the shape property not working
      elevation: 5,
      child: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black.withAlpha(90),
            ),
            child: _imageView(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 30.0, 0.0),
                  child: Text(
                    collectionModel.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 0.0),
                  child: Text(
                    "${collectionModel.totalPhotos} photos",
                    style: TextStyle(color: Colors.white70, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageView() {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: double.infinity,
      height: 180.0,
      imageUrl: collectionModel.coverPhotoUrl,
      placeholder: SizedBox(
        width: double.infinity,
        height: 180.0,
        child: DecoratedBox(
          child: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 0.5,
          )),
          decoration: BoxDecoration(
              color: Color(int.parse(
                  "0xFF${collectionModel.coverPhotoColor.substring(1)}"))),
        ),
      ),
      errorWidget: new Icon(Icons.error),
    );
  }
}
