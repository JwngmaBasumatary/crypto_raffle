import 'package:crypto_raffle/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicServices {
  Future<String> createDynamicLinks({
    bool short,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String _linkToShare = "";

    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: Constants.firebaseDynamicUrl,
        link: Uri.parse(
            "${Constants.appWebsite}/?uid=${user.uid}"),
        androidParameters:
        AndroidParameters(packageName: Constants.packageName),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "The Best ${Constants.coinName} Paying Faucet App",
            description:
            "You can Earn unlimited ${Constants.coinName} using this App",
            imageUrl: Uri.parse(
                Constants.appLogoForDynamicLink)));

    Uri url;
    if (short == true) {
      final ShortDynamicLink shortDynamicLink =
      await dynamicLinkParameters.buildShortLink();
      url = shortDynamicLink.shortUrl;
      _linkToShare = url.toString();
      debugPrint("Short Link $_linkToShare");
    } else {
      url = await dynamicLinkParameters.buildUrl();
      _linkToShare = url.toString();
      debugPrint("Long Link $_linkToShare");
    }

    return _linkToShare;
  }

  Future handleDynamicLinks(BuildContext context) async {
    // STARTUP FROM DYNAMIC LINK LOGIC
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data, context);

    // INTOFOREGROUND FROM DYNAMIC LIBK LOGIC
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkdata) async {
          _handleDeepLink(dynamicLinkdata, context);
        }, onError: (OnLinkErrorException e) async {
      debugPrint("Dynamick Link Error $e");
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data,
      BuildContext context) async {
    final Uri deepLink = data?.link;
    debugPrint(" Handling The DeepLink");
    if (deepLink != null) {
      debugPrint("handle DeepLink In |  deepLink: $deepLink");
      var uid = deepLink.queryParameters['uid'];
      debugPrint("handle DeepLink |  Uid: $uid");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("refId", uid);

/*
      var allNotifier = Provider.of<AllNotifier>(context, listen: false);
      allNotifier.setReferralId(uid);
    }*/
    }
  }
}
