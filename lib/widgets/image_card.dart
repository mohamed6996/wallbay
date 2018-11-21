import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCard extends StatefulWidget {
  final String imageUrl, userProfilePic, userName, color;

  ImageCard(this.imageUrl, this.userProfilePic, this.userName, this.color);

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool isLiked = false, isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Column(
        children: <Widget>[
          new CachedNetworkImage(
            fit: BoxFit.fill,
            width: double.infinity,
            // height: 250.0,
            imageUrl: widget.imageUrl,
            placeholder: SizedBox(
              width: double.infinity,
              height: 250.0,
              child: DecoratedBox(
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 0.5,
                )),
                decoration: BoxDecoration(
                    color:
                        Color(int.parse("0xFF${widget.color.substring(1)}"))),
                //https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
                // use subString to remove the #
              ),
            ),
            errorWidget: new Icon(Icons.error),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        _circleImage(widget.userProfilePic),
                        Padding(padding: EdgeInsets.only(left: 10.0)),
                        Text(
                          widget.userName,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            _onFollowBtnClicked();
                          },
                          child: Icon(Icons.add_circle_outline,
                              size: 25.0,
                              color: isFollowing ? Colors.red : Colors.grey)),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      GestureDetector(
                          onTap: () {
                            _onLikedBtnClicked();
                          },
                          child: Icon(Icons.favorite_border,
                              size: 25.0,
                              color: isLiked ? Colors.red : Colors.grey)),
                    ],
                  ),
                ),
              ])
        ],
      ),
    );
  }

  Widget _circleImage(String url) {
    return Container(
        width: 35.0,
        height: 35.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover, image: new NetworkImage(url))));
  }

  void _onLikedBtnClicked() {
    setState(() {
      if (isLiked)
        isLiked = false;
      else
        isLiked = true;
    });
  }

  void _onFollowBtnClicked() {
    setState(() {
      if (isFollowing)
        isFollowing = false;
      else
        isFollowing = true;
    });
  }
}
