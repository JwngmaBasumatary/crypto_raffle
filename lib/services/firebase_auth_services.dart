import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:crypto_raffle/models/users.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
class User {
  final String uid;

  const User({@required this.uid});
}

class FirebaseAuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirestoreServices fireStoreServices = FirestoreServices();

  Users users = Users();

  User _userFromFirebase(user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential user =
        await _firebaseAuth.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(UserCredential firebaseUser) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constants.users)
        .where("email", isEqualTo: firebaseUser.user.email)
        .get();

    List<DocumentSnapshot> docs = querySnapshot.docs;

    debugPrint("Doc Length (Email check  ${docs.length}");

    return docs.isNotEmpty ? false : true;
  }

  Future<void> addToDb(UserCredential currentUser, String refId) async {
    String username = Tools.getUsername(currentUser.user.email);
    debugPrint(username);
    var firebaseMessaging = FirebaseMessaging.instance;
    String token = await firebaseMessaging.getToken();
/*    String country = await firestoreServices
        .getCountryForSignup()
        .then((value) => value.country);
    print("The Country of the new User is $country");*/

    debugPrint(" Your id Token -$token");
    users = Users(
        uid: currentUser.user.uid,
        email: currentUser.user.email,
        name: currentUser.user.displayName,
        points: 0,
        idToken: token,
        today: DateTime.now().day,
        claimed: 0,
        referralId: "",
        referredBy: refId,
        earnedByReferral: 0,
        createdOn: DateTime.now().toIso8601String(),
        lastLogin: DateTime.now().toIso8601String(),
        //country: country,
        profilePhoto: currentUser.user.photoURL);

    var referralMap = <String, dynamic>{};
    referralMap['name'] = currentUser.user.displayName;
    referralMap['email'] = currentUser.user.email;
    referralMap['uid'] = currentUser.user.uid;
    referralMap['profilePhoto'] = currentUser.user.photoURL;
    referralMap['createdOn'] = DateTime.now().toIso8601String();

    var userMap = <String, dynamic>{};
    userMap['users'] = FieldValue.increment(1);
    var userWelcomeNotificationMap = <String, dynamic>{};
    userWelcomeNotificationMap['title'] = "Welcome ${users.name}";
    userWelcomeNotificationMap['message'] =
        "Congratulations ${users.name} on Creating Account at ${Constants.appName} App. You Just joined a ${Constants.appName} , the community for ${Constants.coinName} Faucets. Now Claim your ${Constants.coinName} and enjoy the App .";
    userWelcomeNotificationMap['time'] =
        DateTime.now().add(const Duration(minutes: 5)).toIso8601String();

    if (refId != "") {
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(currentUser.user.uid)
          .set(users.toMap(users))
          .then((value) async {
        await FirebaseFirestore.instance
            .collection(Constants.generalInformation)
            .doc("total")
            .update(userMap)
            .then((value) async {
          await FirebaseFirestore.instance
              .collection(Constants.users)
              .doc(currentUser.user.uid)
              .collection(Constants.notifications)
              .doc()
              .set(userWelcomeNotificationMap)
              .then((value) async {
            await FirebaseFirestore.instance
                .collection(Constants.users)
                .doc(refId)
                .collection("Referral")
                .doc(currentUser.user.uid)
                .set(referralMap);
          });
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(currentUser.user.uid)
          .set(users.toMap(users))
          .then((value) async {
        await FirebaseFirestore.instance
            .collection(Constants.generalInformation)
            .doc("total")
            .update(userMap)
            .then((value) async {
          await FirebaseFirestore.instance
              .collection(Constants.users)
              .doc(currentUser.user.uid)
              .collection(Constants.notifications)
              .doc()
              .set(userWelcomeNotificationMap);
        });
      });
    }
  }

  Future<void> updateIdToken(UserCredential currentUser) async {
    String email = Tools.getUsername(currentUser.user.email);
    debugPrint(email);

    var firebaseMessaging = FirebaseMessaging.instance;

    String token = await firebaseMessaging.getToken();
    debugPrint(" The New id Token -$token");
    var map = <String, dynamic>{};
    map['idToken'] = token;
    map['today'] = DateTime.now().day;
    map['lastLogin'] = DateTime.now().toIso8601String();
    map["version"] = Constants.releaseVersionCode;

    await FirebaseFirestore.instance
        .collection(Constants.users)
        .doc(currentUser.user.uid)
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

  Future signOutWhenGoogle() async {
    debugPrint("Logout Called");
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _firebaseAuth.signOut();
  }
}
