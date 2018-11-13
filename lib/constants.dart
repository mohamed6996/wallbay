class Constants {
  static final clientId =
      'e35dcccb0b3f8139d54ab3871ea5513bd85c75b503a53ed215135656996a0d05'; // accessKey
  static final clientSecret =
      '17f2a578498caf1fa69f7921bb9d8f384e613321018143706e95687def825851'; // secretkey
  static final String redirectURI = "wallbay://callback";

  static final loginUrl = "https://unsplash.com/oauth/authorize" +
      "?client_id=" +
      clientId +
      "&redirect_uri=" +
      redirectURI +
      "&response_type=" +
      "code" +
      "&scope=" +
      "public+read_user+write_user+read_photos+write_photos+write_likes+read_collections+write_collections";



  // Shared preferences
  static final OAUTH_LOGED_IN = "oauth.loggedin";
  static final OAUTH_ACCESS_TOKEN = "oauth.accesstoken";
  static final OAUTH_TOKEN_TYPE = "oauth.tokentype";
}
