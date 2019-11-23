import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallbay/bloc/favorite_provider.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/photo_user_profile.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import '../constants.dart';

class PhotoDetailsScreen extends StatefulWidget {
  final PhotoModel model;
  final String heroTag;
  final platform = const MethodChannel('wallbay/imageDownloader');

  PhotoDetailsScreen(this.model, this.heroTag);

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  var childButtons = List<UnicornButton>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FavoriteProvider _favoriteProvider;
  MainProvider _mainProvider;
  PreferencesProvider preferencesProvider;

  String _downlaodUrl() {
    String quality = preferencesProvider.downloadQuality.toLowerCase();
    if (quality == 'raw')
      return widget.model.raw;
    else if (quality == 'full')
      return widget.model.full;
    else if (quality == 'regular')
      return widget.model.regular;
    else
      return widget.model.small;
  }

  downloadImage(bool isWallpaper) async {
    try {
      var url = _downlaodUrl();

      var imageId = await ImageDownloader.downloadImage(url,
          destination: AndroidDestinationType.directoryPictures
            ..subDirectory('Wallbay/${widget.model.photoId}.jpg'));

      if (imageId == null) {
        return;
      }

      await repository.reportDownload(widget.model.photoId);

      var path = await ImageDownloader.findPath(imageId);

      if (isWallpaper) {
        await widget.platform.invokeMethod('setWallpaper', path);
      }
    } catch (error) {
      print(error);
    }
  }

  onFavoritePressed() async {
    if (!preferencesProvider.isLogedIn) {
      _loginModalSheet();
      return;
    } else {
      String photoId = widget.model.photoId;
      if (!widget.model.liked_by_user) {
        repository.likePhoto(photoId).then((_) {
          setState(() {
            _favoriteProvider.addFavorite(widget.model);
            widget.model.liked_by_user = true;
          });
        });
      } else {
        repository.unlikePhoto(photoId).then((_) {
          setState(() {
            _favoriteProvider.removeFavorite(widget.model);
            _mainProvider.removeFavorite(widget.model);
            widget.model.liked_by_user = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
    preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: PhotoView(
          heroTag: widget.model.photoId,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          imageProvider: CachedNetworkImageProvider(widget.model.regular),
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showModalSheet();
                },
                child: Row(
                  children: <Widget>[
                    _circleImage(widget.model.largeProfilePhotoUrl, 40),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.model.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
              Row(
                children: <Widget>[
                  IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.file_download, color: Colors.white),
                      onPressed: () => downloadImage(false)),
                  IconButton(
                      icon: Icon(Icons.wallpaper, color: Colors.white),
                      onPressed: () => downloadImage(true)),
                  IconButton(
                      icon: widget.model.liked_by_user
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {
                        onFavoritePressed();
                      }),
                ],
              )
            ],
          )),
    );
  }

  Widget _circleImage(String url, double size) {
    return Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover, image: new NetworkImage(url))));
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(16),
            // height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _circleImage(widget.model.largeProfilePhotoUrl, 60),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.model.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text('Unsplash.com',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.normal))
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  '${widget.model.bio == null ? "" : widget.model.bio}',
                  style: TextStyle(color: Colors.white),
                  //   textAlign: TextAlign.center,F
                ),
                Padding(padding: EdgeInsets.all(12)),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhotoUserProfile(widget.model)));
                  },
                  child: Text('More Photos'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                )
              ],
            ),
          );
        });
  }

  void _loginModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Sign up, it`s free!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.all(8)),
                  Text(
                      'In order to like and download your favorite photos, you have to sign up first.'),
                  Padding(padding: EdgeInsets.all(12)),
                  Center(
                      child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchURL();
                    },
                    child: Text('Sign up or log in'),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  ))
                ],
              ));
        });
  }

  _launchURL() async {
    var loginUrl = constants.loginUrl;
    if (await canLaunch(loginUrl)) {
      await launch(loginUrl);
    } else {
      throw 'Could not launch $loginUrl';
    }
  }
}
