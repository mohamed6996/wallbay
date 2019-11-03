import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallbay/bloc/user_details_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/widgets/image_list.dart';


class PhotoUserProfile extends StatefulWidget {
  PhotoUserProfile(this.model);

  final PhotoModel model;

  @override
  _PhotoUserProfileState createState() => _PhotoUserProfileState();
}

class _PhotoUserProfileState extends State<PhotoUserProfile>
    with AutomaticKeepAliveClientMixin {
  Future _future;

  @override
  void initState() {
    super.initState();
    final UserDetailsProvider userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    _future = userDetailsProvider.fetchData(widget.model.username);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.model.name}'),
          actions: <Widget>[
            FlatButton(
              child: Icon(Icons.portrait),
              onPressed: () {
                String url =
                    'https://unsplash.com/@${widget.model.username}?utm_source=WallBay&utm_medium=referral';
                _launchURL(url);
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: _future,
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
                    return Consumer<UserDetailsProvider>(
                      builder: (context, provider, child) => ImageList(
                        models: provider.photoModelList,
                        isPhotoUserProfile: true,
                      ),
                    );
                  }
              }
            }));
  }

  @override
  bool get wantKeepAlive => true;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
