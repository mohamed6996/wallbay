import 'package:firebase_remote_config/firebase_remote_config.dart';

Constants constants = Constants.instance;

class Constants {
  static Constants instance;

  Constants._();

  static Future<Map<String, String>> create() async {
    instance = Constants._();
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      await remoteConfig.fetch(expiration: const Duration(hours: 5));
      await remoteConfig.activateFetched();
    } catch (e) {
      print(e.toString());
    }

    String clientId = remoteConfig.getString('clientId');
    String clientSecret = remoteConfig.getString('clientSecret');

    Map<String, String> map = Map();
    map.addAll({"clientId": clientId, "clientSecret": clientSecret});

    return map;
  }

  static final String redirectURI = "wallbay://callback";
  String _clientId;
  String _clientSecret;
  String _loginUrl;

  get clientId => _clientId;
  get clientSecret => _clientSecret;
  get loginUrl => _loginUrl;

  set clientId(String val) {
    this._clientId = val;
  }

  set clientSecret(String val) {
    this._clientSecret = val;
  }

  set loginUrl(String clientId) {
    _loginUrl = "https://unsplash.com/oauth/authorize" +
        "?client_id=" +
        clientId +
        "&redirect_uri=" +
        redirectURI +
        "&response_type=" +
        "code" +
        "&scope=" +
        "public+read_user+write_user+read_photos+write_photos+write_likes+read_collections+write_collections";
  }

  static final BASE_URL = "https://api.unsplash.com/";

  // Shared preferences
  static final OAUTH_LOGED_IN = "oauth.loggedin";
  static final OAUTH_ACCESS_TOKEN = "oauth.accesstoken";
  static final OAUTH_TOKEN_TYPE = "oauth.tokentype";
}
