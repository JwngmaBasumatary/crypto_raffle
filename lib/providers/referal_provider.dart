import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class ReferralProvider with ChangeNotifier {
  String _refId;

  ReferralProvider() {
    _refId = "";
  }

  String get refId => _refId;

  void setReferralId(String value) {
    _refId = value;
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

  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) {
    final Uri deepLink = data?.link;
    debugPrint(" Handling The DeepLink");
    if (deepLink != null) {
      debugPrint("handle DeepLink In |  deepLink: $deepLink");
      var uid = deepLink.queryParameters['uid'];
      debugPrint("handle DeepLink |  Uid: $uid");

      setReferralId(uid);
    }
  }
}
