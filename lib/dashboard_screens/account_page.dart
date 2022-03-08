import 'package:crypto_raffle/models/account_data.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = "/accountScreen";

  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountData? appdata;

  var firestoreServices = FirestoreServices();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getUserData();
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    var firebaseAuthServices = FirebaseAuthServices();
    await progressDialog.show();
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();

      final _firebaseAuth = FirebaseAuth.instance;

      progressDialog.hide();
      if (_googleSignIn != null) {
        debugPrint("Google is called");
        await firebaseAuthServices.signOutWhenGoogle();
        progressDialog.hide();
      } else {
        debugPrint("Auth is Called");
        await _firebaseAuth.signOut();
        progressDialog.hide();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  AndroidDeviceInfo androidInfo;

  Future getUserData() async {
    appdata = await firestoreServices.getAppData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: const Text("My Account"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.envelope_open,
              size: 26,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.youtube, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.bell, size: 26),
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),*/
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.blue[100], Colors.blueGrey.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: Colors.indigo),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  appdata != null ?  appdata.profilePhoto
                                      : Constants.appLogoForDynamicLink),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            appdata != null ? appdata.name : "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 1.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            appdata != null && appdata.email != "" ? appdata.email : "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                                letterSpacing: 1.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey,
                      border: Border.all(color: Colors.white)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.account_circle,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Profile Setting",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    subtitle: const Text("Change your profiles",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white)),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.navigate_next)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.monetization_on,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Redeem",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text("Withdraw your funds",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white)),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.navigate_next)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.help,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Help",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text("Contact us for help",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white)),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.navigate_next)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.privacy_tip,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text("Check the privacy policy ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white)),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.navigate_next)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.account_box_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "About us",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text("Check about us",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white)),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.navigate_next)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey),
                  child: ListTile(
                    onTap: () {
                      _signOut(context);
                    },
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text("sign out of the device",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white)),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.navigate_next)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Note- Create only one account per device, we do not support multiple account in one device, if found using multiple account , your payment request will not be paid , and account will be banned",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
