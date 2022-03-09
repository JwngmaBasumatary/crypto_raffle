import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/providers/common_providers.dart';
import 'package:crypto_raffle/screens/policy_page.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:crypto_raffle/widgets/show_loading.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirestoreServices firestoreServices = FirestoreServices();
  bool isLoginPressed = false;

  String? email;
  String? password;
  bool termsAccepted = false;

  @override
  void initState() {
    super.initState();

    getTheREfId();
  }


  var refId = "";

  getTheREfId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    refId = prefs.getString("refId") ?? "";
    debugPrint("Ref Id is $refId");
    // Tools.showToasts(refId);
    setState(() {});
  }

  performEmailPasswordSignup(
      FirebaseAuthServices auth, CommonProviders commonProvider) {
    commonProvider.setIsLoading();
    auth
        .createAccountWithEmailAndPassword(
        "smkbty@gmail.comm", "123456", context, commonProvider)
        .then((user) {
      //debugPrint("User Signed in Already , now have to store to db ${user.user!.email}");
      if (user.user!.uid != "") {
        // debugPrint("Started the process of storing ${user.user!.email}");
        auth.checkIfUserAlreadyExist(user).then((isUserNew) {
          commonProvider.setIsLoading();
          commonProvider.setLoginError("");
          debugPrint("User is ${isUserNew.toString()}");
          if (isUserNew) {
            auth.addToDb(user, refId).then((value) {
              debugPrint(
                  "New User ! Welcome to the App. User is Added to the Database");
            });
          } else {
            auth.updateIdToken(user).then((value) {
              debugPrint(
                  "Old User ! Welcome Back to the App. User Token is Updated to the Database");
            });
            debugPrint(
                "Old User ! Welcome Back to the App. User Token is Updated to the Database");
          }
        });
      } else {
        commonProvider.setIsLoading();
        commonProvider
            .setLoginError("We have Encountered an Error. Please Try Again");
      }
    });
  }

  performEmailPasswordSignIn(
      FirebaseAuthServices auth, CommonProviders commonProvider) {
    commonProvider.setIsLoading();
    auth
        .createAccountWithEmailAndPassword(
        "smkbty@gmail.comm", "123456", context, commonProvider)
        .then((user) {
      //debugPrint("User Signed in Already , now have to store to db ${user.user!.email}");
      if (user.user!.uid != "") {
        // debugPrint("Started the process of storing ${user.user!.email}");
        auth.checkIfUserAlreadyExist(user).then((isUserNew) {
          commonProvider.setIsLoading();
          commonProvider.setLoginError("");
          debugPrint("User is ${isUserNew.toString()}");
          if (isUserNew) {
            auth.addToDb(user, refId).then((value) {
              debugPrint(
                  "New User ! Welcome to the App. User is Added to the Database");
            });
          } else {
            auth.updateIdToken(user).then((value) {
              debugPrint(
                  "Old User ! Welcome Back to the App. User Token is Updated to the Database");
            });
            debugPrint(
                "Old User ! Welcome Back to the App. User Token is Updated to the Database");
          }
        });
      } else {
        commonProvider.setIsLoading();
        commonProvider
            .setLoginError("We have Encountered an Error. Please Try Again");
      }
    });
  }

  performGoogleLogin(
      FirebaseAuthServices auth, CommonProviders commonProvider) {
    commonProvider.setIsLoading();
    auth.signInWithGoogle(context, commonProvider).then((user) {
      debugPrint(
          "User Signed in Already , now have to store to db $user");

      if (user != null) {
        debugPrint("Started the process of storing ${user.user!.email}");
        auth.checkIfUserAlreadyExist(user).then((isUserNew) {
          commonProvider.setIsLoading();
          commonProvider.setLoginError("");
          debugPrint("User is ${isUserNew.toString()}");
          if (isUserNew) {
            auth.addToDb(user, refId).then((value) {
              debugPrint(
                  "New User ! Welcome to the App. User is Added to the Database");
            });
          } else {
            auth.updateIdToken(user).then((value) {
              debugPrint(
                  "Old User ! Welcome Back to the App. User Token is Updated to the Database");
            });
            debugPrint(
                "Old User ! Welcome Back to the App. User Token is Updated to the Database");
          }
        });
      } else {
        Tools.showDebugPrint("Error in Sign In or Sign up");
        commonProvider.setIsLoading();
        commonProvider
            .setLoginError("We have Encountered an Error. Please Try Again");
      }
    });
  }

  autheticateUser(UserCredential user, FirebaseAuthServices auth) {
    if (user.toString().isNotEmpty) {
      auth.checkIfUserAlreadyExist(user).then((isNewUser) {
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

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var commonProvider = Provider.of<CommonProviders>(context, listen: false);
    //bool isLoginPressed = true;
    return WillPopScope(
      onWillPop: () async {
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
        body: Stack(
          children: <Widget>[
            Container(
              height: _height,
              width: _width,
              color: Colors.black,
              child: SafeArea(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Consumer<CommonProviders>(
                              builder: (_, commonProvider, child) {
                                return commonProvider.loginError != ""
                                    ? _buildErrorWidget(
                                    commonProvider.loginError, commonProvider)
                                    : const SizedBox.shrink();
                              }),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(Constants.appLogo),
                              ),
                            ),
                          ),
                          buildHeadingAutoSizeText(),
                          SizedBox(
                            height: _height * 0.1,
                          ),
                          const Text(
                            "Welcome to ${Constants.appName}, you are on the right place to earn ${Constants.coinName} easily.",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Checkbox(
                                  value: termsAccepted,
                                  onChanged: (value) {
                                    setState(() {
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
                                                  color: Colors.lightGreenAccent)),
                                          TextSpan(
                                              text: ' \n to the  ',
                                              style: TextStyle(
                                                  color: Colors.lightGreenAccent)),
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
                            child: SignInButton(
                              Buttons.Google,
                              onPressed: () async {
                                if (termsAccepted) {
                                  final auth = Provider.of<FirebaseAuthServices>(
                                      context,
                                      listen: false);
                                  try {
                                    performGoogleLogin(auth, commonProvider);
                                  } catch (error) {
                                    commonProvider.setLoginError(error as String);
                                  }
                                } else {
                                  Tools.showToasts(
                                      "Accept the Terms And Conditions");
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          refId != ""
                              ? Text("Referred By :-  $refId")
                              : const SizedBox()
                        ],
                      ),
                    ),
                  )),
            ),
            Consumer<CommonProviders>(builder: (_, commonProvider, child) {
              return commonProvider.isLoading
                  ? showLoadingDialog()
                  : const SizedBox.shrink();
            }),
            // isLoginPressed ? showLoadingDialog() : const SizedBox.shrink(),
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

  _buildErrorWidget(String errorMessage, CommonProviders commonProvider) {
    return Container(
      color: Colors.yellow,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: const Icon(
                  Icons.error_outline,
                  color: Colors.black,
                ),
                onPressed: () {}),
          ),
          Expanded(
            child: AutoSizeText(
              errorMessage,
              maxLines: 3,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  commonProvider.setLoginError("");
                }),
          ),
        ],
      ),
    );
  }
}