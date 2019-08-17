import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';


class PhotoDetailsScreen extends StatefulWidget {
  final PhotoModel model;
  final PhotoRepository photoRepository;
  final SharedPreferences sharedPreferences;

  PhotoDetailsScreen(this.model, this.photoRepository, this.sharedPreferences);

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  var childButtons = List<UnicornButton>();

  void fabDialChildren() {
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Info",
        labelBackgroundColor: Colors.black,
        labelColor: Colors.white,
        labelHasShadow: false,
        currentButton: FloatingActionButton(
          heroTag: "chat",
          backgroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.info_outline, color: Colors.white),
          onPressed: () async {
//            FirebaseUser user = await widget._homePageBE.getUser();
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => ChatPage(user, user.uid)));
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Set as wallpaper",
        labelBackgroundColor: Colors.black,
        labelColor: Colors.white,
        labelHasShadow: false,
        currentButton: FloatingActionButton(
          heroTag: "sell",
          backgroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.wallpaper, color: Colors.white),
          onPressed: () {
//            Navigator.of(context)
//                .push(MaterialPageRoute(builder: (context) => SellPageFE()));
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Download",
        labelBackgroundColor: Colors.black,
        labelColor: Colors.white,
        labelHasShadow: false,
        currentButton: FloatingActionButton(
          heroTag: "download",
          backgroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.file_download, color: Colors.white),
          onPressed: () {
//            Navigator.of(context)
//                .push(MaterialPageRoute(builder: (context) => SellPageFE()));
          },
        )));
  }

  @override
  void initState() {
    super.initState();
    fabDialChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Theme(
        data: ThemeData(
            accentIconTheme: IconThemeData(color: Colors.white),
            accentColor: Colors.orange),
        child: UnicornDialer(
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.menu),
            childButtons: childButtons),
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
                color: Colors.black.withOpacity(0.65),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 0, bottom: 0),
                  child: Row(
                    children: <Widget>[
                      _circleImage(widget.model.mediumProfilePhotoUrl),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.model.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text('Unsplash.com',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal))
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
        width: 40,
        height: 40,
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
