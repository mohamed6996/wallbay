import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/photo_user_profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:flutter/services.dart';

class PhotoDetailsScreen extends StatefulWidget {
  final PhotoModel model;
  final PhotoRepository photoRepository;
  final SharedPreferences sharedPreferences;
  final String heroTag;
  final platform = const MethodChannel('wallbay/imageDownloader');

  PhotoDetailsScreen(
      this.model, this.photoRepository, this.sharedPreferences, this.heroTag);

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  var childButtons = List<UnicornButton>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFabVisible = true, isSheetVisible = false;
  Widget w;

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
            _showModalSheet();
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
          onPressed: () async {
            downloadImage(true);
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
          onPressed: () async {
            Map<PermissionGroup, PermissionStatus> permissions =
                await PermissionHandler()
                    .requestPermissions([PermissionGroup.storage]);

            downloadImage(false);
          },
        )));
  }

  downloadImage(bool isWallpaper) async {
    try {
      var url = widget.model.downloadPhotoUrl;

      var imageId = await ImageDownloader.downloadImage(url,
          destination: AndroidDestinationType.directoryPictures
            ..subDirectory('Wallbay/${widget.model.photoId}.jpg'));

      if (imageId == null) {
        return;
      }

      var path = await ImageDownloader.findPath(imageId);
      //  var fileName = await ImageDownloader.findName(imageId);
      //  var size = await ImageDownloader.findByteSize(imageId);
      //  var mimeType = await ImageDownloader.findMimeType(imageId);

      if (isWallpaper) {
        await widget.platform.invokeMethod('setWallpaper', path);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fabDialChildren();
    w = PhotoUserProfile(
        widget.model, widget.photoRepository, widget.sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Theme(
        data: ThemeData(
            accentIconTheme: IconThemeData(color: Colors.white),
            accentColor: Colors.orange),
        child: Visibility(
          visible: isFabVisible,
          child: UnicornDialer(
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.menu),
              childButtons: childButtons),
        ),
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
                      _circleImage(widget.model.mediumProfilePhotoUrl, 40),
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
                    _circleImage(widget.model.mediumProfilePhotoUrl, 60),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.model.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text('Unsplash.com',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.normal))
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  '${widget.model.bio == null ? "" : widget.model.bio}',
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //  _showBottomSheet();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => w));
                    },
                    child: Text('More Photos'))
              ],
            ),
          );
        });
  }

  void _showBottomSheet() {
    setState(() {
      isFabVisible = false;
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return DraggableScrollableSheet(
              expand: false,
//          initialChildSize: 0.5,
//          maxChildSize: 1,
//          minChildSize: 0.25,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                print('called');

                //return w;

//                return Container(
//                  child: PhotoUserProfile(widget.model, widget.photoRepository,
//                      widget.sharedPreferences),
//                );
                return Container(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 25,
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Text('Item $index'));
                    },
                  ),
                );
              });
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              isFabVisible = true;
            });
          }
        });
  }
}



//todo to be deleted
class SetWallPaper extends StatefulWidget {
  final String url;

  SetWallPaper(this.url);

  @override
  _SetWallPaperState createState() => _SetWallPaperState();
}

class _SetWallPaperState extends State<SetWallPaper> {
  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Set Wallpaper'),
        content: isDownloading == false
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    _listItem('Home Screen', Icons.home, () {
                      setState(() {
                        isDownloading = true;
                      });

                      Wallpaper.ImageDownloadProgress(widget.url)
                          .listen((data) {}, onDone: () {
                        //  await Wallpaper.homeScreen();
                        print('calllllled');
                        //  Navigator.of(context).pop();
                        //  isDownloading = false;
                      });
                    }),
                    _listItem('Lock Screen', Icons.lock, () {
                      Wallpaper.ImageDownloadProgress(widget.url).listen(
                          (data) {
                        setState(() {
                          isDownloading = true;
                        });
                      }, onDone: () async {
                        await Wallpaper.lockScreen();
                        Navigator.of(context).pop();
                        isDownloading = false;
                      });
                    }),
                    _listItem('Both', Icons.phone_android, () {
                      Wallpaper.ImageDownloadProgress(widget.url).listen(
                          (data) {
                        setState(() {
                          isDownloading = true;
                        });
                      }, onDone: () async {
                        await Wallpaper.homeScreen();
                        await Wallpaper.lockScreen();
                        Navigator.of(context).pop();
                        isDownloading = false;
                      });
                    })
                  ])
            : Container(
                height: 100,
                child: Center(child: CircularProgressIndicator())));
  }

  _listItem(String desc, IconData icon, VoidCallback callback) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              Icon(icon, color: Colors.orange),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
              Text(desc),
            ],
          ),
        ),
      ),
    );
  }
}
