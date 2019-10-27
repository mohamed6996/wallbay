import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/coll_photos_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/widgets/image_list.dart';

class CollectionPhotos extends StatefulWidget {
  final int id;
  final String title;

  CollectionPhotos(this.id, this.title);

  @override
  _CollectionPhotosState createState() => _CollectionPhotosState();
}

class _CollectionPhotosState extends State<CollectionPhotos> {
  @override
  Widget build(BuildContext context) {
    final CollPhotosProvider collPhotosProvider =
        Provider.of<CollPhotosProvider>(context,listen: false);
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: FutureBuilder(
            future: collPhotosProvider.fetchData(widget.id),
            builder: (context, AsyncSnapshot<List<PhotoModel>> snapshot) {
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
                    return Consumer<CollPhotosProvider>(
                        builder: (context, provider, child) {
                      return ImageList(
                        models: snapshot.data,
                        isCollectionPhotos: true,
                      );
                    });
                  }
              }
            }));
  }


}
