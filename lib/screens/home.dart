import 'package:flutter/material.dart';
import 'package:wallbay/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:wallbay/nav_bar_tabs/favorites_tab.dart';
import 'package:wallbay/nav_bar_tabs/collections_tab.dart';
import 'package:wallbay/nav_bar_tabs/main_feed_tab.dart';
import 'package:wallbay/screens/manage_account.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:wallbay/model/access_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Key keyMainFeed = PageStorageKey('mainFeed');
  final Key keyCollections = PageStorageKey('collections');
  final Key keyFavorites = PageStorageKey('favorites');

  MainFeedTab mainFeedTab;
  CollectionsTab collectionsTab;
  FavoritesTab favoritesTab;

  final PageStorageBucket bucket = PageStorageBucket();
  List<Widget> pages;
  Widget currentPage;
  int currentTab = 0;

  StreamSubscription _sub;
  String msg = "";

  @override
  initState() {
    super.initState();
    initUniLinks();
    mainFeedTab = MainFeedTab(key: keyMainFeed);
    collectionsTab = CollectionsTab(key: keyCollections);
    favoritesTab = FavoritesTab(key: keyFavorites);

    pages = [mainFeedTab,collectionsTab, favoritesTab ];

    currentPage = mainFeedTab;
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallbay"),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            title: Text("Collections"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Favorite"),
          ),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, // solve grey status bar color
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              accountName: Text("Mohamed Ali"),
              accountEmail: Text("mohamed.ali6996@hotmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("M"),
              ),
            ),
            ListTile(
              title: Text("Manage Account"),
              trailing: Icon(Icons.settings),
              onTap: () => _onSelectedItem(0),
            ),
          ]),
    );
  }

  void _onSelectedItem(int index) {
    Navigator.of(context).pop(); // close the drawer
    //Navigator.push(context, ManageAccountPage());
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ManageAccountPage()));
  }

  _getAccessToken(String client_id, String client_secret, String redirect_uri,
      String code, String grant_type) async {
    var url = "https://unsplash.com/oauth/token";

    var query_params = {
      "client_id": client_id,
      "client_secret": client_secret,
      "redirect_uri": redirect_uri,
      "code": code,
      "grant_type": grant_type
    };

    var response = await http.post(url, body: query_params);

    Map<String, dynamic> map = json.decode(response.body);
    var accessToken = AccessToken.fromJson(map);
    _saveAccessTokenToPrefs(accessToken);
    setState(() {
      msg = accessToken.access_token;
    });
  }

  Future<Null> initUniLinks() async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString(Constants.OAUTH_ACCESS_TOKEN);
    setState(() {
      msg = accessToken == null ? "" : accessToken;
    });
    getUriLinksStream().listen((Uri uri) {
      if (uri != null) {
        setState(() {
          String code = uri.queryParameters["code"];
          print("code:" + code);
          if (code != null) {
            _getAccessToken(Constants.clientId, Constants.clientSecret,
                Constants.redirectURI, code, "authorization_code");
          }
        });
      }
    }, onError: (err) {
      print("error:" + err.toString());
    });
  }

  void _saveAccessTokenToPrefs(AccessToken body) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setBool(Constants.OAUTH_LOGED_IN, true);
    prefs.setString(Constants.OAUTH_ACCESS_TOKEN, body.access_token);
    prefs.setString(Constants.OAUTH_TOKEN_TYPE, body.token_type);
  }
}
