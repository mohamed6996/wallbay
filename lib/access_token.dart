

class AccessToken{
   String access_token;
   String refresh_token;
   String token_type;
   String scope;
   int created_at;

   AccessToken(this.access_token,this.refresh_token ,this.token_type, this.scope, this.created_at);

   AccessToken.fromJson(Map jsonMap){
     access_token = jsonMap["access_token"];
     refresh_token = jsonMap["refresh_token"];
     token_type = jsonMap["token_type"];
     scope = jsonMap["scope"];
     created_at = jsonMap["created_at"];
   }
}