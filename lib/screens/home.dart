import 'package:flutter/material.dart';
import 'package:wallbay/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:wallbay/nav_bar_tabs/favorites_tab.dart';
import 'package:wallbay/nav_bar_tabs/collections_tab.dart';
import 'package:wallbay/nav_bar_tabs/main_feed_tab.dart';
import 'package:wallbay/nav_bar_tabs/settings_tab.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:wallbay/model/access_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:wallbay/utils/shared_prefs.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initSharedPref(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                return MainTabs(snapshot.data);
              } else {
                return Container();
              }
              break;
            default:
              return Container();
          }
        });
  }

  Future<SharedPreferences> _initSharedPref() async {
    return SharedPrefs.getPrefs();
  }
}

class MainTabs extends StatefulWidget {
  final SharedPreferences preferences;

  MainTabs(this.preferences);

  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  final Key keyMainFeed = PageStorageKey('mainFeed');
  final Key keyCollections = PageStorageKey('collections');
  final Key keyFavorites = PageStorageKey('favorites');

  MainFeedTab mainFeedTab;
  CollectionsTab collectionsTab;
  FavoritesTab favoritesTab;
  SettingsTab settingsTab;

  final PageStorageBucket bucket = PageStorageBucket();
  List<Widget> pages;
  Widget currentPage;
  int currentTab = 0;

  // StreamSubscription _sub;  //todo  init links

  @override
  initState() {
    super.initState();
    _initTabs();
    initUniLinks();
  }

  @override
  void dispose() {
    super.dispose();
    //  _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),

//      body: IndexedStack(
//        index: currentTab,
//        children: pages,
//      ),

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentTab,
        onItemSelected: (index) => setState(() {
          currentTab = index;
          currentPage = pages[index];
        }),
        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.trending_up),
              title: Text('Trending'),
              activeColor: Colors.black,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
            icon: Icon(Icons.layers),
            title: Text('Collections'),
            inactiveColor: Colors.black,
            activeColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
            inactiveColor: Colors.black,
            activeColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            inactiveColor: Colors.black,
            activeColor: Colors.black,
          ),
        ],
      ),
    );
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
  }

  Future<Null> initUniLinks() async {
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
    widget.preferences
        .setString(Constants.OAUTH_ACCESS_TOKEN, body.access_token);
    widget.preferences.setString(Constants.OAUTH_TOKEN_TYPE, body.token_type);
    widget.preferences.setBool(Constants.OAUTH_LOGED_IN, true);
  }

  Future<void> _initTabs() async {
    mainFeedTab = MainFeedTab(keyMainFeed, widget.preferences);
    collectionsTab = CollectionsTab(keyCollections, widget.preferences);
    favoritesTab = FavoritesTab(keyFavorites, widget.preferences);
    settingsTab = SettingsTab();

    pages = [mainFeedTab, collectionsTab, favoritesTab, settingsTab];

    currentPage = mainFeedTab;
  }
}
