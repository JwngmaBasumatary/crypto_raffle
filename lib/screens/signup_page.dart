import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto_raffle/screens/policy_page.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/widgets/show_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirestoreServices firestoreServices = FirestoreServices();
  bool isLoginPressed = false;
  bool termsAccepted = false;

  @override
  void initState() {
    super.initState();
    //getInValidCountries();
    getTheREfId();
  }

  var listInValidCountries = [];

  var refId = "";

  getTheREfId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    refId = prefs.getString("refId") ?? "";
    debugPrint("Ref Id is $refId");
   // Tools.showToasts(refId);
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();


  performLogin(FirebaseAuthServices auth) {
    setState(() {
      isLoginPressed = true;
    });
    auth.signInWithGoogle().then((user) {
      if (user != null) {
        autheticateUser(user, auth);
      } else {
        setState(() {
          isLoginPressed = false;
        });
        _warning = "We have Encountered an Error. Please Try Again";
        debugPrint("Error Occured During Loin");
      }
    });
  }

  autheticateUser(UserCredential user, FirebaseAuthServices auth) {
    if (user != null) {
      auth.authenticateUser(user).then((isNewUser) {
        isLoginPressed = false;
        debugPrint("User is ${isNewUser.toString()}");
        if (isNewUser) {
          auth.addToDb(user, refId).then((value) {
            debugPrint(
                "New User ! Welcome to the App. User is Added to the Database");
          });
        } else {
          auth.updateIdToken(user).then((value) {
            debugPrint(
                "Old User ! Welcome Back to the App. User Token is Updated to the Database");
          });
        }
      });
    } else {
      setState(() {
        isLoginPressed = false;
      });
    }
  }

  bool isPresent(String countryName) {
    Tools.showToasts("Checking");
    var countries = listInValidCountries.toList();
    for (int i in countries) {
      Tools.showToasts(countries[i]);
    }
    return countries.contains(countryName);
  }

  @override
  Widget build(BuildContext context)  {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    //bool isLoginPressed = true;
    return WillPopScope(
onWillPop: ()async {
        return await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Exit"),
                content: const Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Stack(
          children: <Widget>[
            Container(

              height: _height,
              width: _width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: const [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.blue[700]!,
                    Colors.blue[500]!,
                    Colors.blue[300]!,
                    Colors.blue[100]!,
                  ],
                ),
              ),
              child: SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _buildErrorWidget(),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius:80,
                          backgroundImage: AssetImage(Constants.appLogo),
                        ),
                      ),
                      buildHeadingAutoSizeText(),
                      SizedBox(
                        height: _height * 0.1,
                      ),
                      const Text(
                        "Welcome to ${Constants.appName}, you are on the right place to earn ${Constants.coinName} easily.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                              value: termsAccepted,

                                 onChanged: (bool? value) {  setState(() {
                                    termsAccepted = value!;
                                  });
                              }),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const PolicyPage();
                                  }));
                                },
                                child: RichText(
                                  text: const TextSpan(
                                    text: '',
                                    style: TextStyle(color: Colors.red),
                                    /*defining default style is optional */
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              ' I have read, understood and agree',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: ' \n to the  ',
                                          style: TextStyle(
                                              color: Colors.black)),
                                      TextSpan(
                                        text: 'Terms of use.',
                                        style: TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.1,
                      ),
                      Visibility(
                        visible: true,
                        child: GoogleSignInButton(
                            splashColor: Colors.red,
                            onPressed: () async {
                          if (termsAccepted) {
                            final auth = FirebaseAuthServices();
                            performLogin(auth);
                          } else {
                            Tools.showToasts("Accept the Terms And Conditions");
                          }
                        }),
                      ),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      refId != "" ? Text("Referred By :-  $refId") : const SizedBox()
                    ],
                  ),
                ),
              )),
            ),
            isLoginPressed ? showLoadingDialog() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  AutoSizeText buildHeadingAutoSizeText() {
    String headerText = Constants.appName;

    return AutoSizeText(
      headerText,
      maxLines: 1,
      style: const TextStyle(fontSize: 40, color: Colors.white),
    );
  }


  _buildErrorWidget() {
    if (_warning != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  IconButton(icon: const Icon(Icons.error_outline), onPressed: () {}),
            ),
            Expanded(
              child: AutoSizeText(
                _warning!,
                maxLines: 3,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _warning = null;
                    });
                  }),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
