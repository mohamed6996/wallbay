import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/utils/shared_prefs.dart';
import 'package:wallbay/widgets/image_list.dart';


class CollectionPhotos extends StatefulWidget {
  final int id;
  final String title;

  CollectionPhotos(this.id, this.title);

  @override
  _CollectionPhotosState createState() => _CollectionPhotosState();
}

class _CollectionPhotosState extends State<CollectionPhotos> {
  final _memoizer = AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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

                    //return Center(child: Text(snapshot.data.toString()),);
                    return ImageList(
                      models: snapshot.data,
                     // sharedPreferences: sharedPreferences,
                      isFavoriteTab: false,
                      isCollectionPhotos: true,
                      collectionId: widget.id,
                    );
                  }
              }
            })
    );
  }

  _fetchData() async {
    return _memoizer.runOnce(() async {
      var prefs = await SharedPrefs.getPrefs();
      return PhotoRepository(prefs).fetchCollectionPhotos(1,widget.id);
    });
  }
}
