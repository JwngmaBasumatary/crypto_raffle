import 'package:crypto_raffle/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

class RemoteConfigServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> checkForNewVersion() async {
    debugPrint("checkForNewVerion is Called");
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    final RemoteConfig remoteConfig = RemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      double newVersion = double.parse(remoteConfig
          .getString(Constants.appVersionFromRemote)
          .trim()
          .replaceAll(".", ""));

      if (newVersion <= currentVersion) {
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (exception) {
      debugPrint(exception.toString());
    } catch (exception) {
      debugPrint(
          'Unable to fetch remote config. Cached or default values will be used ');
    }

    return false;
  }

  Future<bool> checkWithdrawalLimitReached(String withdrawLimits) async {
    int currentVersion = 1000000;
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      double withdrawLimit = double.parse(
          remoteConfig.getString(withdrawLimits).trim().replaceAll(".", ""));

      if (withdrawLimit > currentVersion) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (exception) {
      debugPrint(exception.toString());
    } catch (exception) {
      debugPrint(
          'Unable to fetch remote config. Cached or default values will be used for $withdrawLimits');
    }
    return false;
  }

  Future<String> checkLatestVersion() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    String requiredString="";
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      requiredString = remoteConfig.getString(Constants.appVersionFromRemote);
      return requiredString;
    } on PlatformException catch (exception) {
      debugPrint(exception.toString());
    } catch (exception) {
      debugPrint(
          'Unable to fetch remote config. Cached or default values will be used for force_update_current_version');
    }
    return requiredString;
  }

  Future<String> getValueFromRemoteConfig(String value) async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      var requiredString = remoteConfig.getString(value);
      return requiredString;
    } on PlatformException catch (exception) {
      debugPrint(exception.toString());
    } catch (exception) {
      debugPrint(
          'Unable to fetch remote config. Cached or default values will be used for $value');
    }
    return "";
  }
}
