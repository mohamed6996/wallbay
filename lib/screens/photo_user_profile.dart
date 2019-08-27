import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/image_list.dart';

class PhotoUserProfile extends StatefulWidget {
  PhotoUserProfile(this.model, this.photoRepository, this.sharedPreferences);

  final PhotoModel model;
  final PhotoRepository photoRepository;
  final SharedPreferences sharedPreferences;


  @override
  _PhotoUserProfileState createState() => _PhotoUserProfileState();
}

class _PhotoUserProfileState extends State<PhotoUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.model.name}'),),
        body: FutureBuilder(
            future: _fetchData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: SpinKitHourGlass(
                    color: Colors.deepOrange,
                  ));
                  break;
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    return ImageList(
                      models: snapshot.data,
                      sharedPreferences: widget.sharedPreferences,
                      isFavoriteTab: false,
                      isPhotoUserProfile: true,
                      userName: widget.model.username,
                    );
                  }
              }
            }));


  }

  _fetchData() async {
    return PhotoRepository(widget.sharedPreferences).fetchUsersPhotos(widget.model.username,1);
  }
}


