import 'package:flutter/material.dart';
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

class _CollectionPhotosState extends State<CollectionPhotos>
    with AutomaticKeepAliveClientMixin {
  Future<List<PhotoModel>> _future;

  @override
  void initState() {
    super.initState();
    final CollPhotosProvider _collPhotosProvider =
        Provider.of<CollPhotosProvider>(context, listen: false);
    _future = _collPhotosProvider.fetchData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<List<PhotoModel>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
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

  @override
  bool get wantKeepAlive => true;
}
