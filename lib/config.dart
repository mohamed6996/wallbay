import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  String _clintId = '';
  String _clientSecret = '';

  set clientId(String val) => _clintId = val;
  get clientId => _clintId;

  set clientSecret(String val) => _clientSecret = val;
  get clientSecret => _clientSecret;

  ConfigProvider() {
    initRemoteConfig();
  }

  initRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();

    this.clientId = remoteConfig.getString('clientId');
    this.clientSecret = remoteConfig.getString('clientSecret');
  }
}
