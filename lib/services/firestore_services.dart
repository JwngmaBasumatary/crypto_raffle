import 'dart:convert';
import 'package:crypto_raffle/models/coinbase_commerce.dart';
import 'package:crypto_raffle/models/user_stream.dart';
import 'package:crypto_raffle/models/updated_values_model.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_raffle/models/account_data.dart';
import 'package:crypto_raffle/models/current_day.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto_raffle/models/country.dart';
import 'package:crypto_raffle/models/coin_address_model.dart';
import 'package:crypto_raffle/models/users.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:http/http.dart' as http;

class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // getting Notifications
  getNotifications() async {
    final user = auth.currentUser;
    return _db
        .collection(Constants.users)
        .doc(user.uid)
        .collection(Constants.notifications)
        .orderBy("time", descending: false)
        .snapshots();
  }

  // getting Notifications
  getAnnouncements() async {
    return _db
        .collection(Constants.announcements)
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future getToday() async {
    debugPrint("Get tODAY  is called");
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('today'));
  }

  Future<UpdatedValuesModel> getUpdatedValues() async {
    final user = auth.currentUser;
    return await _db.collection(Constants.users).doc(user.uid).get().then(
        (documentSnapshot) =>
            UpdatedValuesModel.fromJson(documentSnapshot.data()));
  }

  Future<AccountData> getAppData() async {
    final user = auth.currentUser;
    return await _db.collection(Constants.users).doc(user.uid).get().then(
        (documentSnapshot) => AccountData.fromJson(documentSnapshot.data()));
  }

  Future<String> getReferralId(String docName) async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get(docName));
  }

  Future<AccountData> getAccountData() async {
    final user = auth.currentUser;
    return await _db.collection(Constants.users).doc(user.uid).get().then(
        (documentSnapshot) => AccountData.fromJson(documentSnapshot.data()));
  }

  Future addToday() async {
    final user = auth.currentUser;
    var map = <String, dynamic>{};
    map['clicks_left'] = 30;
    map['basicScratchLeft'] = 30;
    map['silverScratchLeft'] = 30;
    map['goldScratchLeft'] = 30;
    map['mindGameLeft'] = 30;
    map['ticTacToeLeft'] = 30;
    map['today'] = DateTime.now().day;
    map['version'] = Constants.releaseVersionCode;
    await FirebaseFirestore.instance
        .collection(Constants.users)
        .doc(user.uid)
        .update(map)
        .then((value) {
      debugPrint("The Date  and Clicks Left is Updated");
    }).catchError((error) {
      debugPrint("Error for write $error");
      Tools.showToasts("Error $error");
    });
  }

  Future addIntervalTimer(String timerTitle) async {
    final user = auth.currentUser;
    var map = <String, dynamic>{};
    map[timerTitle] = DateTime.now().day;
    await _db.collection(Constants.users).doc(user.uid).update(map);
  }

  Future<List<DocumentSnapshot>> getTransactionss() async {
    final user = auth.currentUser;
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.users)
        .doc(user.uid)
        .collection(Constants.transactions)
        .orderBy("date", descending: false);
    QuerySnapshot querySnapshot = await query.get();
    _list = querySnapshot.docs;

    return _list;
  }

  Future<List<DocumentSnapshot>> getGiveAwayWinners() async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.weeklyGiveAwayWinners)
        .orderBy("date", descending: false);
    QuerySnapshot querySnapshot = await query.get();
    _list = querySnapshot.docs;

    return _list;
  }

  Future<List<DocumentSnapshot>> getReferredUsers() async {
    final user = auth.currentUser;
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.users)
        .doc(user.uid)
        .collection(Constants.referral)
        .orderBy("createdOn", descending: false);
    QuerySnapshot querySnapshot = await query.get();
    _list = querySnapshot.docs;

    return _list;
  }

  Future getPoints() async {
    final user = auth.currentUser;
    debugPrint("Get Points is called");
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('points'));
  }

  Future getTotalUsers() async {
    debugPrint("Get TOTAL USERS is called");
    return await _db
        .collection(Constants.generalInformation)
        .doc("total")
        .get()
        .then((documentSnapshot) => documentSnapshot.get('users'));
  }

  Future getLastNoticeDate() async {
    debugPrint("Get The last Notified date  is called");
    return await _db
        .collection(Constants.generalInformation)
        .doc("lastUpdated")
        .get()
        .then((documentSnapshot) => documentSnapshot.get('lastNotificeDate'));
  }

  Future getClicks() async {
    final user = auth.currentUser;
    debugPrint("Get Clicks is called");
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('clicks'));
  }

  Future getName() async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('name'));
  }

  Future getPaymentScreenshotAddedToday() async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('name'));
  }

  Future getCurrentUid() async {
    final user = auth.currentUser;
    return user.uid.toString();
  }

  Future getCountry() async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('country'));
  }

  Future getCoinbaseEmail() async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('coinbase_email'));
  }

  Future<Users> getUserprofile() async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => Users.fromMap(documentSnapshot.data()));
  }

  Future<CoinAddressModel> getUserAddress() async {
    final user = auth.currentUser;
    return await _db.collection(Constants.users).doc(user.uid).get().then(
        (documentSnapshot) =>
            CoinAddressModel.fromJson(documentSnapshot.data()));
  }

  Future addPoints(int points) async {
    final user = auth.currentUser;
    var map = <String, dynamic>{};
    map['points'] = points;
    await _db.collection(Constants.users).doc(user.uid).update({
      "points": FieldValue.increment(points),
      "clicks": FieldValue.increment(1),
      "clicks_left": FieldValue.increment(-1),
    });
  }

  Future<bool> addPointsForAction(int points, String title, String clicksLeft,
      int hrs, int min, int sec) async {
    bool finalVal = false;
    final user = auth.currentUser;
    var map = <String, dynamic>{};
    map['points'] = points;
    await _db.collection(Constants.users).doc(user.uid).update({
      "points": FieldValue.increment(points),
      "clicks": FieldValue.increment(1),
      clicksLeft: FieldValue.increment(-1),
    }).then((value) async {
      var nextClaimMap = <String, dynamic>{};
      nextClaimMap[title] = (DateTime.now()
                  .add(Duration(hours: hrs, minutes: min, seconds: sec))
                  .millisecondsSinceEpoch /
              1000)
          .round();
      await _db
          .collection(Constants.users)
          .doc(user.uid)
          .update(nextClaimMap)
          .then((value) {
        finalVal = true;
      });
    }).catchError((error) {
      debugPrint("Error for write $error");
      // Tools.showToasts("Error $error");
    });
    return finalVal;
  }

  //Withdraw
  Future<void> addWithdrawRequest(BuildContext context, String method,
      int points, String walletAddress, int clicks, String referredBy) async {
    //update to user Database
    final user = auth.currentUser;
    // String uid = await Constants.prefs.getString(Constants.uid);
    await _db.collection(Constants.users).doc(user.uid).update({
      "points": 0,
      "clicks": 0,
    }).then((val) async {
      //save the transactions in Withdraw Request
      var withdrawMap = <String, dynamic>{};
      withdrawMap["points"] = points;
      withdrawMap["date"] = DateTime.now().toIso8601String();
      withdrawMap["method"] = method;
      withdrawMap["status"] = "pending";
      withdrawMap["wallet_address"] = walletAddress;
      withdrawMap["uid"] = user.uid;
      withdrawMap["title"] = "Withdrawal to ${method.toLowerCase()}";
      withdrawMap["clicks"] = clicks;
      withdrawMap["referredBy"] = referredBy;
      withdrawMap["version"] = Constants.releaseVersionCode;
      String docId = user.uid + DateTime.now().toIso8601String();
      await _db
          .collection(Constants.withdrawRequest)
          .doc(docId)
          .set(withdrawMap)
          .then((value) async {
        await _db
            .collection(Constants.users)
            .doc(user.uid)
            .collection("transactions")
            .doc(docId)
            .set(withdrawMap)
            .then((val) {
          debugPrint("Withdraw Request have been added");
        });
      }).catchError((error) {
        _showError(context);
      });
    });
  }

  //Update Profile
  Future<void> updateUserProfile(BuildContext context, Users users) async {
    //update to user Database
    final user = auth.currentUser;
    //  String uid = await Constants.prefs.getString(Constants.uid);
    var userMap = <String, dynamic>{};
    userMap['name'] = users.name;
    userMap['country'] = users.country;

    await _db
        .collection(Constants.users)
        .doc(user.uid)
        .update(userMap)
        .then((val) {
      debugPrint("User profile Updated");
    }).catchError((error) {
      _showError(context);
    });
  }

  //Update Profile
  Future<void> updateAddress(
      BuildContext context, CoinAddressModel addressModel) async {
    final user = auth.currentUser;
    var addressMap = <String, dynamic>{};
    addressMap['coin_address'] = addressModel.coinAddress;

    await _db
        .collection(Constants.users)
        .doc(user.uid)
        .update(addressMap)
        .then((val) {
      debugPrint("User Address Updated");
    }).catchError((error) {
      _showError(context);
    });
  }

  Future<void> participate(String week) async {
    final user = auth.currentUser;
    var eventExist = await _db
        .collection(Constants.weeklyEvent)
        .doc(
            "${DateTime.now().year.toString()}_${DateTime.now().month.toString()}_$week")
        .get();

    if (eventExist.exists) {
      await _db
          .collection(Constants.weeklyEvent)
          .doc(
              "${DateTime.now().year.toString()}_${DateTime.now().month.toString()}_$week")
          .update({
        "participants": FieldValue.arrayUnion([user.uid])
      });
    } else {
      await _db
          .collection(Constants.weeklyEvent)
          .doc(
              "${DateTime.now().year.toString()}_${DateTime.now().month.toString()}_$week")
          .set({
        "participants": FieldValue.arrayUnion([user.uid])
      });
    }
  }

  Future<String> getEmail() async {
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get('email'));
  }

  Future<Country> getCountryForSignup() async {
    String url = "http://ip-api.com/json";
    var response = await http.get(
      Uri.parse(url),
    );
    var jsonResponse = json.decode(response.body);
    //Tools.showToasts(jsonResponse);
    debugPrint(jsonResponse);
    return Country.fromJson(jsonResponse);
  }


  Future<CurrentDay> getCurrentDay() async {
    String url = "https://worldclockapi.com/api/json/est/now";
    var response = await http.get(
      Uri.parse(url),
    );
    var jsonResponse = json.decode(response.body);
    return CurrentDay.fromJson(jsonResponse);
  }

  Future getNextClickTime(String timerTitle) async {
    debugPrint("Get Last Clicked Time is called");
    final user = auth.currentUser;

    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((value) => value.data()[timerTitle]);
  }

  Future<List<DocumentSnapshot>> getTopUsers() async {
    List<DocumentSnapshot> _list = [];
    Query query = _db
        .collection(Constants.users)
        .orderBy("points", descending: true)
        .limit(50);
    QuerySnapshot querySnapshot = await query.get();
    _list = querySnapshot.docs;

    return _list;
  }

  Future getUserId() async {
    return auth.currentUser;
  }

  Stream<UserStream> getUserData(String uid) {
    return _db
        .collection(Constants.users)
        .doc(uid)
        .snapshots()
        .map((event) => UserStream.fromMap(event.data()));
  }

  Future setReferralLink(String refLink) async {
    final user = auth.currentUser;
    var referalMap = <String, dynamic>{};
    referalMap['referralId'] = refLink;
    await _db.collection(Constants.users).doc(user.uid).update(referalMap);
  }

  Future getLastClicked(String timerTitle) async {
    debugPrint("Get Last Clicked Time is called");
    final user = auth.currentUser;
    return await _db
        .collection(Constants.users)
        .doc(user.uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.get(timerTitle));
  }

  getLiveEvents(String eventCollectionName) async {
    return _db
        .collection(eventCollectionName)
        .orderBy("id", descending: false)
        .limit(4)
        .snapshots();
  }

  Future getUserInfo() async {
    final user = auth.currentUser;
    return await _db.collection(Constants.users).doc(user.uid).get();
  }

  Future<CoinbaseCommerce> generatePaymentLink(
      int amount, int luckyNumber, String eventTitle, int eventId) async {
    final user = auth.currentUser;
    String url =
        "https://herokumainserver.herokuapp.com/api/v1/coinbaseCommerce/pay";
    var response = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "name": user.displayName,
      "description": " This is Entry Fee for the Event",
      "uid": user.uid,
      "email": user.email,
      "amount": amount,
      "title": eventTitle,
      "luckyNumber": luckyNumber,
      "eventId": eventId,
    });
    var jsonResponse = json.decode(response.body);
    //Tools.showToasts(jsonResponse);
    debugPrint(jsonResponse);
    return CoinbaseCommerce.fromJson(jsonResponse);
  }

  Future<CoinbaseCommerce> payWithCoinbase({int amount, int luckyNumber, String eventTitle, int eventId}) async {
    String url =
        "https://herokumainserver.herokuapp.com/api/v1/coinbaseCommerce/pay";
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": "jshf",
        "description": " This is Entry Fee for the Event",
        "uid": "sjdhjs",
        "email": "smkbty@jshj.com",
        "amount": 22,
        "title": "Title",
        "luckyNumber": 22,
        "eventId": 22,
      }),
    );
    return CoinbaseCommerce.fromJson(jsonDecode(response.body));
  }

  Future<bool> addPaymentScreenshotImage(
    String url,
  ) async {
    bool imageUploaded = false;
    final user = auth.currentUser;

    var paymentProofMap = <String, dynamic>{};
    paymentProofMap["uid"] = user.uid;
    paymentProofMap["url"] = url;
    paymentProofMap["status"] = "pending";
    paymentProofMap['date'] = DateTime.now().toIso8601String();

    var eventExist =
        await _db.collection(Constants.paymentProofs).doc(user.uid).get();

    if (!eventExist.exists) {
      await _db
          .collection(Constants.paymentProofs)
          .doc(user.uid)
          .set(paymentProofMap)
          .then((value) {
        imageUploaded = true;
      });
      return imageUploaded;
    } else {
      return imageUploaded;
    }
  }
}

_showError(BuildContext context) {
  Fluttertoast.showToast(
      msg: "Error Occured, Please Try Again",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
