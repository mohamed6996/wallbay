import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/main_provider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:wallbay/utils/colors.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PreferencesProvider preferencesProvider =
        Provider.of<PreferencesProvider>(context);
    return FutureBuilder(
        future: preferencesProvider.initSharedPrefs(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) return Container();
          return MainTabs();
        });
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
      bottomNavigationBar: BottomNavyBar(
        showElevation: true,
        selectedIndex: currentTab,
        onItemSelected: (index) => setState(() {
          currentTab = index;
          currentPage = pages[index];
        }),
        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.trending_up),
              title: Text('Trending'),
              activeColor: kactiveColor,
              inactiveColor: kinactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.layers),
              title: Text('Collections'),
              activeColor: kactiveColor,
              inactiveColor: kinactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
              activeColor: kactiveColor,
              inactiveColor: kinactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: kactiveColor,
              inactiveColor: kinactiveColor),
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
    preferencesProvider.accessToken = body.access_token;
    preferencesProvider.accessTokenType = body.token_type;
    preferencesProvider.isLogedIn = true;
  }

  Future<void> _initTabs() async {
    mainFeedTab = MainFeedTab(keyMainFeed);
    collectionsTab = CollectionsTab(keyCollections);
    favoritesTab =
        FavoritesTab(keyFavorites);
    settingsTab = SettingsTab();

    pages = [mainFeedTab, collectionsTab, favoritesTab, settingsTab];

    currentPage = mainFeedTab;
  }
}
