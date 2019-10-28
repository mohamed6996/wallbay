// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wallbay/model/collection_model.dart';
// import 'package:wallbay/widgets/collection_card.dart';

// class UserCollectionList extends StatefulWidget {
//   final List<CollectionModel> models;
//   final SharedPreferences sharedPreferences;

//   UserCollectionList({Key key, this.models, this.sharedPreferences})
//       : super(key: key);

//   @override
//   _UserCollectionListState createState() => _UserCollectionListState();
// }

// class _UserCollectionListState extends State<UserCollectionList> {
//   @override
//   Widget build(BuildContext context) {
//     return _buildListView(widget.models);
//   }

//   Widget _buildListView(List<CollectionModel> models) {
//     return Container(
//         child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: models.length + 1,
//             itemBuilder: (context, int index) {
//               if (index == models.length) {
//                 if (models.length >= 10) {
//                   return seeMore();
//                 }
//                 if (models.length == 0) {
//                   return Container(
//                     child:
//                         Padding(
//                           padding: const EdgeInsets.only(left:4.0,top: 4.0),
//                           child: Text("The user has no collections yet",style:TextStyle(fontSize: 12.0),),
//                         ),
//                   );
//                 } else
//                   return Container();
//               } else {
//                 return CollectionCard(models[index], true);
//               }
//             }));
//   }

//   Widget seeMore() {
//     return Center(
//       child: FlatButton(
//           onPressed: () {},
//           child: Text("See more"),
//           padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0)),
//     );
//   }
// }
