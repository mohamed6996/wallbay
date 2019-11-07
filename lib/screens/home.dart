import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTabs();
  }
}

class MainTabs extends StatefulWidget {
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

  PreferencesProvider preferencesProvider;

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
    preferencesProvider = Provider.of<PreferencesProvider>(context);
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (index) => setState(() {
          currentTab = index;
          currentPage = pages[index];
        }),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor:
            preferencesProvider.theme == 0 ? Colors.black : Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            title: Text('Collections'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
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
          if (code != null) {
            _getAccessToken(constants.clientId, constants.clientSecret,
                Constants.redirectURI, code, "authorization_code");
          }
        });
      }
    }, onError: (err) {
      print("error:" + err.toString());
    });
  }

  void _saveAccessTokenToPrefs(AccessToken body) async {
    preferencesProvider.accessToken = body.access_token;
    preferencesProvider.accessTokenType = body.token_type;
    preferencesProvider.isLogedIn = true;
  }

  Future<void> _initTabs() async {
    mainFeedTab = MainFeedTab(keyMainFeed);
    collectionsTab = CollectionsTab(keyCollections);
    favoritesTab = FavoritesTab(keyFavorites);
    settingsTab = SettingsTab();

    pages = [mainFeedTab, collectionsTab, favoritesTab, settingsTab];

    currentPage = mainFeedTab;
  }
}
