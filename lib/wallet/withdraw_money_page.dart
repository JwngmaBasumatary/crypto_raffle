//import 'package:auto_size_text/auto_size_text.dart';
//import 'package:crypto_raffle/screens/account_page.dart';
//import 'package:crypto_raffle/screens/address_page.dart';
//import 'package:crypto_raffle/screens/home_page.dart';
//import 'package:crypto_raffle/services/firebase_auth_services.dart';
//import 'package:crypto_raffle/services/firestore_services.dart';
//import 'package:crypto_raffle/utils/constants.dart';
//import 'package:crypto_raffle/utils/tools.dart';
//import 'package:crypto_raffle/widgets/message_dialog_with_ok.dart';
//import 'package:crypto_raffle/widgets/notification_dialog_with_ok.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:progress_dialog/progress_dialog.dart';
//import 'package:provider/provider.dart';
//
//class WithdrawMoney extends StatefulWidget {
//  @override
//  _WithdrawMoneyState createState() => _WithdrawMoneyState();
//}
//
//class _WithdrawMoneyState extends State<WithdrawMoney> {
//  int pointsToShow;
//  String withdrawal_address = "";
//  TextEditingController _withdrawal_addressController = TextEditingController();
//  FirebaseAuthServices authServices = FirebaseAuthServices();
//  FirestoreServices _fireStoreServices = FirestoreServices();
//
//  int selectedLocation = 0;
//  bool walletSelected = false;
//  List<String> withdrawalServices = Constants.withdrawalServices;
//
//  String referredBy = "";
//
//  @override
//  void initState() {
//    super.initState();
//    SystemChannels.textInput.invokeMethod('TextInput.hide');
//    _getPointsToShow();
//    _getReferredBy();
//  }
//
//  _getReferredBy() async {
//    var firestoreServices =
//        Provider.of<FirestoreServices>(context, listen: false);
//    await firestoreServices.getReferralId("referredBy").then((value) {
//      //Tools.showToasts(value);
//      if (value != null || value != "") {
//        referredBy = value;
//      } else {
//        referredBy = "";
//      }
//    });
//
//    setState(() {});
//  }
//
//  _getPointsToShow() async {
//    var firestoreServices =
//        Provider.of<FirestoreServices>(context, listen: false);
//    int point = await firestoreServices.getPoints();
//    setState(() {
//      pointsToShow = point;
//    });
//  }
//
//  bool showAddAddress = false;
//  bool claimed = false;
//
//  checkWithdrawalLimitReached(context) async {
//    int cureentPoints = 12;
//    final RemoteConfig remoteConfig = await RemoteConfig.instance;
//
//    try {
//      await remoteConfig.setConfigSettings(RemoteConfigSettings(
//        fetchTimeout: const Duration(seconds: 10),
//        minimumFetchInterval: Duration.zero,
//      ));
//      await remoteConfig.fetchAndActivate();
//      double withdraw_limit = double.parse(
//          remoteConfig.getString('withdraw_limit').trim().replaceAll(".", ""));
//      if (withdraw_limit > cureentPoints) {
//        setState(() {
//          showAddAddress = true;
//        });
//      }
//    } on PlatformException catch (exception) {
//      // Fetch throttled.
//      debugPrint(exception);
//    } catch (exception) {
//      debugPrint('Unable to fetch remote config. Cached or default values will be '
//          'used');
//    }
//  }
//
//  showEmptyWalletDialog(String message) {
//    showDialog(
//        context: context,
//        builder: (context) => CustomDialogWithOk(
//              title: "Empty Wallet",
//              description: "You  have not added your $message yet.",
//              primaryButtonText: "Ok",
//              primaryButtonRoute: AddressPage.routeName,
//            ));
//  }
//
//  getTheWithdrawalAddress(ProgressDialog progressDialog, int value) async {
//    switch (value) {
//      case 0:
//        //Coinbase
//        await progressDialog.show();
//        await _fireStoreServices.getUserAddress().then((value) {
//          progressDialog.hide();
//
//          if (value.coin_address == "" || value.coin_address == null) {
//            setState(() {
//              showEmptyWalletDialog("Coinbase Email");
//              _withdrawal_addressController.text =
//                  "Please Save Your Address First";
//            });
//            return;
//          } else {
//            setState(() {
//              walletSelected = true;
//              _withdrawal_addressController.text = value.coin_address;
//              withdrawal_address = _withdrawal_addressController.text;
//            });
//            return;
//          }
//        });
//        break;
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    ProgressDialog progressDialog =
//        ProgressDialog(context, isDismissible: false);
//    return Scaffold(
//      body: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              Container(
//                height: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.grey),
//                child: Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Center(
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Center(
//                                child: Text(
//                              "Balance:",
//                              style:
//                                  TextStyle(color: Colors.white, fontSize: 18),
//                            )),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Center(
//                              child: Text(
//                                pointsToShow == null
//                                    ? "0"
//                                    : "${(pointsToShow * Constants.decimal).toStringAsFixed(Constants.decimal_length)} ${Constants.symbol}",
//                                style: TextStyle(
//                                    color: Colors.white, fontSize: 18),
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                      Text(
//                        pointsToShow == null
//                            ? "Wait For Few Seconds To get loaded"
//                            : "Loaded",
//                        style: TextStyle(color: Colors.white, fontSize: 8),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 10,
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 20),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    Flexible(
//                      child: AutoSizeText(
//                        "Note- Add Your Withdrawal Address, before withdrawal",
//                        maxLines: 2,
//                        style: TextStyle(fontSize: 15),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        Navigator.push(context,
//                            MaterialPageRoute(builder: (context) {
//                          return AddressPage();
//                        }));
//                      },
//                      child: Container(
//                        color: Colors.red,
//                        child: Text("Here"),
//                      ),
//                    )
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 10),
//                child: Container(
//                  color: Colors.grey[700],
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: <Widget>[
//                      AutoSizeText(
//                        "Select the Wallet service",
//                        maxLines: 1,
//                        textAlign: TextAlign.center,
//                        style: TextStyle(fontSize: 15),
//                      ),
//                      Container(
//                        color: Colors.grey[600],
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: PopupMenuButton(
//                            color: Colors.grey,
//                            child: Row(
//                              children: <Widget>[
//                                Text(
//                                  withdrawalServices[selectedLocation],
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                  ),
//                                ),
//                                Icon(
//                                  Icons.arrow_drop_down,
//                                  color: Colors.white,
//                                  size: 30,
//                                )
//                              ],
//                            ),
//                            onSelected: (int value) {
//                              setState(() {
//                                selectedLocation = value;
//                                getTheWithdrawalAddress(progressDialog, value);
//                              });
//                            },
//                            itemBuilder: (BuildContext context) {
//                              return <PopupMenuItem<int>>[
//                                PopupMenuItem(
//                                  child: Text(
//                                    withdrawalServices[0],
//                                    style: TextStyle(
//                                        color: Colors.white, fontSize: 15),
//                                  ),
//                                  value: 0,
//                                ),
//                              ];
//                            },
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 20),
//                child: Container(
//                    child: TextFormField(
//                  style: TextStyle(fontSize: 14),
//                  controller: _withdrawal_addressController,
//                  enabled: false,
//                  decoration: InputDecoration(
//                    labelText: "Wallet Address",
//                    labelStyle: TextStyle(fontSize: 15),
//                    fillColor: Colors.white,
//                    border: new OutlineInputBorder(
//                      borderRadius: new BorderRadius.circular(10.0),
//                      borderSide: new BorderSide(),
//                    ),
//                  ),
//                  keyboardType: TextInputType.text,
//                  onSaved: (String value) => withdrawal_address = value,
//                )),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Container(
//                  width: MediaQuery.of(context).size.width * 0.7,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.blue),
//                  child: FlatButton(
//                    onPressed: () async {
//                      ProgressDialog pr =
//                          ProgressDialog(context, isDismissible: false);
//
//                      int points = await _fireStoreServices.getPoints();
//
//                      int clicks = await _fireStoreServices.getClicks();
//         /*             String referredBy =
//                          await _fireStoreServices.getReferralId("referredBy");*/
//
//                     // Tools.showToasts(referredBy);
//
//                      if (withdrawalServices[selectedLocation] == false) {
//                        return Tools.showToasts(
//                            "Select Your Wallet Email First");
//                      }
//                      if (withdrawal_address == "") {
//                        return Tools.showToasts(
//                            "Please Add Your Address First");
//                      }
//                      if (claimed) {
//                        return Tools.showToasts(
//                            "Your withdrawal has been sent already");
//                      }
//                      double pointToWithdraw = double.parse(
//                          (points * Constants.decimal)
//                              .toStringAsFixed(Constants.decimal_length));
//
//                      if (pointToWithdraw >=
//                          Constants.minimum_withdrawal_limit) {
//                        await pr.show();
//                        addTheWithdrawRequestToDb(
//                                withdrawalServices[selectedLocation],
//                                points,
//                                withdrawal_address,
//                                clicks,
//                                referredBy)
//                            .then((value) async {
//                          claimed = true;
//                          await pr.hide();
//                          setState(() {
//                            pointsToShow = 0;
//                          });
//
//                          showDialog(
//                              context: context,
//                              barrierDismissible: false,
//                              builder: (context) => NotificationDialogWithOk(
//                                    title: "Withdrawal request",
//                                    description:
//                                        "Your withdrawal will be processed within 72 Hours, till then You can Share our App with others or Review us in playstore, It will help us to run smoothly. ",
//                                    primaryButtonText: "Ok",
//                                    primaryButtonRoute: HomePage.routeName,
//                                  ));
//                        });
//                      } else {
//                        Tools.showToasts(
//                            "You have Low ${Constants.coin_name} in your wallet, Min Withdraw limit is ${Constants.minimum_withdrawal_limit} ${Constants.coin_name}");
//                      }
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.symmetric(horizontal: 10),
//                      child: Text(
//                        "Withdraw",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  )),
//              SizedBox(
//                height: 20,
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  "Note- Minimum Withdrawal Limit is ${Constants.minimum_withdrawal_limit} ${Constants.symbol}",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: 10, color: Colors.red),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  "Note-${Constants.approval_time} ",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: 10),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  "${Constants.withdraw_note}",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: 10, color: Colors.red),
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  showDialogCantWithdrawToday(
//    String title,
//    String desc,
//  ) {
//    showDialog(
//        context: context,
//        builder: (context) => NotificationDialogWithOk(
//              title: title,
//              description: desc,
//              primaryButtonText: "Ok",
//              primaryButtonRoute: AccountScreen.routeName,
//            ));
//  }
//
//  Future addTheWithdrawRequestToDb(String method, int points,
//      String wallet_address, int clicks, String referredBy) async {
//    _fireStoreServices.addWithdrawRequest(
//        context,
//        withdrawalServices[selectedLocation],
//        points,
//        wallet_address,
//        clicks,
//        referredBy);
//  }
//}
