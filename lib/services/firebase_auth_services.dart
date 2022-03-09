import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_raffle/models/country.dart';
import 'package:crypto_raffle/models/users.dart';
import 'package:crypto_raffle/providers/common_providers.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class User {
  final String uid;

  const User({required this.uid});
}

class FirebaseAuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirestoreServices firestoreServices = FirestoreServices();

  Users? users;

  User _userFromFirebase(user) {
    return User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future signInWithGoogle(BuildContext context,  CommonProviders commonProviders) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Tools.showDebugPrint("Error in catch $e");
      commonProviders
          .setLoginError("You have Encounterred Error While Logging In");
      commonProviders.setIsLoading();
    }
  }

  // create user with email and password
  Future createAccountWithEmailAndPassword(String email, String password,
      BuildContext context, CommonProviders commonProvider) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      commonProvider
          .setLoginError("You have Encounterred Error While Logging In");
      commonProvider.setIsLoading();
    }
  }

  // Sign user with email and password
  Future signInUserWithWithEmailAndPassword(String email, String password,
      BuildContext context, CommonProviders commonProvider) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      commonProvider
          .setLoginError("You have Encounterred Error While Logging In");
      commonProvider.setIsLoading();
    }
  }

  //send reset password Link
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkIfUserAlreadyExist(UserCredential firebaseUser) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constants.users)
        .where("email", isEqualTo: firebaseUser.user?.email)
        .get();

    List<DocumentSnapshot> docs = querySnapshot.docs;

    debugPrint("Doc Length (Email check  ${docs.length}");

    return docs.isNotEmpty ? false : true;
  }

  //sign out the user , when logged in with google auth
  Future signOutWhenGoogle() async {
    debugPrint("Logout Called");
    bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (isGoogleSignedIn) {
      sharedPreferences.clear();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      return await _firebaseAuth.signOut();
    } else {
      sharedPreferences.clear();
      return _firebaseAuth.signOut();
    }
  }

  Future<void> addToDb(UserCredential currentUser, String refId) async {
    String? username = currentUser.user!.displayName;
    debugPrint(username);
    var firebaseMessageing = FirebaseMessaging.instance;
    String? token = await firebaseMessageing.getToken();
    DateTime ntpDT = await NTP.now();
    String country =
    await firestoreServices.getCountryForSignup().then((value) => value!);
    // Timestamp startDate = await NTP.now();
    debugPrint("The Country of the new User is $country");

    debugPrint(" Your id Token -$token");
    users = Users(
        uid: currentUser.user?.uid,
        email: currentUser.user?.email,
        name: currentUser.user?.displayName,
        points: 0,
        idToken: token,
        today: ntpDT.day,
        claimed: 0,
        referralId: "",
        referredBy: refId,
        earnedByReferral: 0,
        lastLogin: Timestamp.now(),
        createdOn: Timestamp.now(),
        country: country,
        profilePhoto: currentUser.user?.photoURL);

    var userMap = <String, dynamic>{};
    userMap['uid'] = users?.uid;
    userMap['email'] = users?.email;
    userMap['name'] = users?.name;
    userMap['points'] = users?.points;
    userMap['idToken'] = users?.idToken;


    // userMap['goldScratchTimer'] =
    //     Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 24)));
    // userMap['successClaims'] = users?.successClaims;
    // userMap['silverScratchTimer'] =
    //     Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 24)));
    // userMap['basicScratchTimer'] =
    //     Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 24)));
    // userMap['diamondScratchTimer'] =
    //     Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 24)));

    userMap['today'] = users?.today;
    userMap['claimed'] = users?.claimed;
    userMap['referralId'] = users?.referralId;
    userMap['referredBy'] = users?.referredBy;
    userMap['earnedByReferral'] = users?.earnedByReferral;
    userMap['lastLogin'] = users?.lastLogin;
    userMap['createdOn'] = users?.createdOn;
    userMap['country'] = users?.country;
    userMap['profilePhoto'] = users?.profilePhoto;

    var referralMap = <String, dynamic>{};
    referralMap['name'] = currentUser.user?.displayName;
    referralMap['email'] = currentUser.user?.email;
    referralMap['uid'] = currentUser.user?.uid;
    referralMap['profilePhoto'] = currentUser.user?.photoURL;
    referralMap['createdOn'] = FieldValue.serverTimestamp();

    var totalUserMaps = <String, dynamic>{};
    totalUserMaps['users'] = FieldValue.increment(1);
    var userWelcomeNotificationMap = <String, dynamic>{};
    userWelcomeNotificationMap['title'] = "Welcome ${users?.name}";
    userWelcomeNotificationMap['message'] =
    "Congratulations ${users?.name} on Creating Account at ${Constants.appName} App. You Just joined a ${Constants.appName} , the community for ${Constants.coinName} Faucets. Now Claim your ${Constants.coinName} and enjoy the App .";
    userWelcomeNotificationMap['time'] = Timestamp.now()
        .toDate()
        .add(const Duration(minutes: 5))
        .toIso8601String();
    if (refId != "") {
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(currentUser.user?.uid)
          .set(userMap)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection(Constants.generalInformations)
            .doc("generalInformations")
            .update(totalUserMaps)
            .then((value) async {
          await FirebaseFirestore.instance
              .collection(Constants.users)
              .doc(currentUser.user?.uid)
              .collection(Constants.notifications)
              .doc()
              .set(userWelcomeNotificationMap)
              .then((value) async {
            await FirebaseFirestore.instance
                .collection(Constants.users)
                .doc(refId)
                .collection("Referral")
                .doc(currentUser.user?.uid)
                .set(referralMap);
          });
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(currentUser.user?.uid)
          .set(userMap)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection(Constants.generalInformations)
            .doc("generalInformations")
            .update(totalUserMaps)
            .then((value) async {
          await FirebaseFirestore.instance
              .collection(Constants.users)
              .doc(currentUser.user?.uid)
              .collection(Constants.notifications)
              .doc()
              .set(userWelcomeNotificationMap);
        });
      });
    }
  }

  Future<void> updateIdToken(UserCredential currentuser) async {
    var firebaseMessageing = FirebaseMessaging.instance;

    String? token = await firebaseMessageing.getToken();
    debugPrint(" The New id Token -$token");
    var map = <String, dynamic>{};
    map['idToken'] = token;
    map['today'] = Timestamp.now().toDate().day;
    map['lastLogin'] = FieldValue.serverTimestamp();
    map["version"] = Constants.releaseVersionCode;

    await FirebaseFirestore.instance
        .collection(Constants.users)
        .doc(currentuser.user?.uid)
        .update(map);
  }

  Future<void> updateUserProfile(Users users) async {
    var map = <String, dynamic>{};
    map["name"] = users.name;
    map["email"] = users.email;
    await FirebaseFirestore.instance
        .collection(Constants.users)
        .doc(users.uid)
        .update(map);
  }
}