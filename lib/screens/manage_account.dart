import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';
import 'package:wallbay/model/access_token.dart';
import 'package:wallbay/constants.dart';
import 'dart:async';

class ManageAccountPage extends StatefulWidget {
  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  String _accessToken = "empty";
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadAccessTokenFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        elevation: 1.0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _launchURL();
                // Navigator.pop(context, true);
                Navigator.of(context).pop(); // close the drawer
              },
              child: Text("Log In"),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Create Account"),
            ),
            Text(_accessToken == null ? "" : _accessToken),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    var loginUrl = Constants.loginUrl;
    if (await canLaunch(loginUrl)) {
      await launch(loginUrl);
    } else {
      throw 'Could not launch $loginUrl';
    }
  }

  _loadAccessTokenFromPrefs() async {
    SharedPreferences.getInstance().then(((prefs){
      setState(() {
        _isLoggedIn = prefs.getBool(Constants.OAUTH_LOGED_IN);
        _accessToken = prefs.getString(Constants.OAUTH_ACCESS_TOKEN);
        prefs.getString(Constants.OAUTH_TOKEN_TYPE);
      });


    }));

  }
}

