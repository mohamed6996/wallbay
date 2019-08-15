import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/photo_details_model.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/user_collection_list.dart';
import 'package:wallbay/widgets/user_photo_list.dart';
import 'package:share/share.dart';

class PhotoDetailsScreen extends StatefulWidget {
  final PhotoModel model;
  final PhotoRepository photoRepository;
  final SharedPreferences sharedPreferences;

  PhotoDetailsScreen(this.model, this.photoRepository, this.sharedPreferences);

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        // heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.arrow_downward),
              backgroundColor: Colors.red,
              label: 'Download',
              labelStyle: TextStyle(fontSize: 15),
              onTap: () => print('FIRST CHILD')),
          SpeedDialChild(
            child: Icon(Icons.wallpaper),
            backgroundColor: Colors.blue,
            label: 'Set as wallpaper',
            labelStyle: TextStyle(fontSize: 15),
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.info_outline,
            ),
            backgroundColor: Colors.green,
            label: 'Info',
            labelStyle: TextStyle(fontSize: 15),
            onTap: () => print('THIRD CHILD'),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
              imageUrl: widget.model.regularPhotoUrl,
            ),
          ),
          Positioned(
              bottom: 0,
              height: 85,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 0, bottom: 0),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _circleImage(widget.model.mediumProfilePhotoUrl),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.model.name,
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Text('Unsplash.com')
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _circleImage(String url) {
    return Container(
        width: 60,
        height: 60,
        decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover, image: new NetworkImage(url))));
  }
}

//class PhotoDetailsScreen extends StatefulWidget {
//  final PhotoModel model;
//  final PhotoRepository photoRepository;
//  final SharedPreferences sharedPreferences;
//
//  PhotoDetailsScreen(this.model, this.photoRepository, this.sharedPreferences);
//
//  @override
//  PhotoDetailsScreenState createState() {
//    return new PhotoDetailsScreenState();
//  }
//}
//
//class PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
//  String shareLink = "";
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.share),
//                onPressed: () => Share.share(shareLink),
//                tooltip: "Share",
//              ),
//              IconButton(
//                icon: Icon(Icons.file_download),
//                onPressed: () => onDownloadPressed(),
//                tooltip: "Download",
//              )
//            ],
//            floating: false,
//            // if true, icons will disappear on collapsing
//            pinned: true,
//            expandedHeight: 250.0,
//            flexibleSpace: FlexibleSpaceBar(
//                collapseMode: CollapseMode.parallax,
//                background: CachedNetworkImage(
//                  fit: BoxFit.cover,
//                  imageUrl: widget.model.regularPhotoUrl,
//                )),
//          ),
//          SliverList(
//              delegate: SliverChildListDelegate([
//            userInfo(),
//            Divider(height: 12.0),
//            imageState(),
//            Divider(height: 12.0),
//            Padding(
//              padding: const EdgeInsets.fromLTRB(4.0, 18.0, 0.0, 4.0),
//              child: Text("More photsos by  ${widget.model.name}"),
//            ),
//            Container(
//              child: userPhotosList(),
//              height: 365.0,
//            ),
//            FlatButton(
//              onPressed: () {},
//              child: Text("SEE MORE"),
//              padding: EdgeInsets.all(16.0),
//            ),
//            //  FlatButton(onPressed: () {}, child: Text("SEE MORE"))
//          ])),
//        ],
//      ),
//    );
//  }
//
//  Widget userPhotosList() {
//    return FutureBuilder(
//      future: _fetchUserPhotos(),
//      builder: (BuildContext context, snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting:
//            return SpinKitCircle(
//              color: Colors.purple,
//            );
//            break;
//          default:
//            if (snapshot.hasError) {
//              return Center(child: Text("Error: ${snapshot.error}"));
//            }
//            if (snapshot.hasData) {
//              return UserPhotoList(
//                  models: snapshot.data,
//                  sharedPreferences: widget.sharedPreferences);
//            }
//        }
//      },
//    );
//  }
//
//  Widget userInfo() {
//    return Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Padding(
//              padding: EdgeInsets.all(5.0),
//              child: Row(
//                children: <Widget>[
//                  _circleImage(widget.model.mediumProfilePhotoUrl),
//                  Padding(padding: EdgeInsets.only(left: 10.0)),
//                  Text(
//                    widget.model.name,
//                    style: TextStyle(fontSize: 12.0),
//                  ),
//                ],
//              )),
//          Padding(
//            padding: const EdgeInsets.all(5.0),
//            child: Row(
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(widget.model.liked_by_user
//                      ? Icons.favorite
//                      : Icons.favorite_border),
//                  onPressed: () {
//                    onFavoritePressed();
//                  },
//                ),
////                IconButton(
////                  icon: Icon(
////                    Icons.file_download,
////                    color: Colors.grey,
////                  ),
////                  onPressed: () {
////                    onDownloadPressed();
////                  },
////                ),
//              ],
//            ),
//          ),
//        ]);
//  }
//
//  Widget imageState() {
//    return FutureBuilder(
//      future: _fetchImageState(),
//      builder: (BuildContext context, snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting:
//            return Center(
//                child: SpinKitCircle(
//              size: 60.0,
//              color: Colors.purple,
//            ));
//            break;
//          default:
//            if (snapshot.hasError) {
//              return Center(child: Text("Error: ${snapshot.error}"));
//            }
//            if (snapshot.hasData) {
//              return state(snapshot.data);
//            }
//        }
//      },
//    );
//  }
//
//  Widget state(PhotoDetailsModel model) {
//    shareLink = model.shareLink;
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
//                  child: Icon(Icons.place),
//                ),
//                Text("${model.country}"),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
//                  child: Icon(Icons.date_range),
//                ),
//                Text(model.created_at.split("T")[0])
//              ],
//            ),
//          ],
//        ),
//        Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Icon(Icons.favorite),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text("${model.likes} likes"),
//                )
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Icon(Icons.file_download),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text("${model.downloads} downloads"),
//                )
//              ],
//            ),
//          ],
//        )
//      ],
//    );
//  }
//
//  Widget _circleImage(String url) {
//    return Container(
//        width: 35.0,
//        height: 35.0,
//        decoration: new BoxDecoration(
//            shape: BoxShape.circle,
//            image: new DecorationImage(
//                fit: BoxFit.cover, image: new NetworkImage(url))));
//  }
//
//  onFavoritePressed() {
//    String photoId = widget.model.photoId;
//    if (!widget.model.liked_by_user) {
//      widget.photoRepository.likePhoto(photoId).then((_) {
//        setState(() {
//          widget.model.liked_by_user = true;
//        });
//      });
//    } else {
//      widget.photoRepository.unlikePhoto(photoId).then((_) {
//        setState(() {
//          widget.model.liked_by_user = false;
//        });
//      });
//    }
//  }
//
//  onDownloadPressed() {}
//
//  _fetchUserPhotos() async {
//    return PhotoRepository(widget.sharedPreferences)
//        .fetchUserPhotos(1, widget.model.username);
//  }
//
//  _fetchImageState() async {
//    return PhotoRepository(widget.sharedPreferences)
//        .fetchPhotoDetails(widget.model.photoId);
//  }
//
////todo next version
//  Widget collectionList() {
//    return FutureBuilder(
//      future: _fetchCollection(),
//      builder: (BuildContext context, snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting:
//            return Center(
//                child: SpinKitCircle(
//              color: Colors.purple,
//            ));
//            break;
//          default:
//            if (snapshot.hasError) {
//              return Center(child: Text("Error: ${snapshot.error}"));
//            }
//            if (snapshot.hasData) {
//              return UserCollectionList(
//                models: snapshot.data,
//                sharedPreferences: widget.sharedPreferences,
//              );
//            }
//        }
//      },
//    );
//  }
//
//  _fetchCollection() async {
//    return PhotoRepository(widget.sharedPreferences)
//        .fetchUserCollections(1, widget.model.username);
//  }
//}
//
//
