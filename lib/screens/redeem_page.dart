//import 'dart:math';
//
//import 'package:crypto_raffle/services/firebase_auth_services.dart';
//import 'package:crypto_raffle/services/firestore_services.dart';
//import 'package:crypto_raffle/utils/tools.dart';
//import 'package:crypto_raffle/wallet/transaction_page.dart';
//import 'package:crypto_raffle/wallet/withdraw_money_page.dart';
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//
//class RedeemScreen extends StatefulWidget {
//  static const String routeName = "/RedeemScreen";
//
//  @override
//  _RedeemScreenState createState() => _RedeemScreenState();
//}
//
//class _RedeemScreenState extends State<RedeemScreen> {
//  FirestoreServices firestoreServices = FirestoreServices();
//  FirebaseAuthServices authServices = FirebaseAuthServices();
//
//  @override
//  void initState() {
//    super.initState();
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return DefaultTabController(
//      length: 2,
//      child: Scaffold(
//        appBar: AppBar(
//          title: Text("Redeem"),
//          bottom: TabBar(
//            indicatorSize: TabBarIndicatorSize.label,
//            indicatorColor: Tools.multiColors[Random().nextInt(4)],
//            labelStyle: TextStyle(
//              fontSize: 12,
//            ),
//            isScrollable: false,
//            tabs: <Widget>[
//              Tab(
//                child: Text("Withdraw",
//                    style:
//                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
//                icon: Icon(
//                  FontAwesomeIcons.dollarSign,
//                  size: 18,
//                ),
//              ),
//              Tab(
//                child: Text("Transations",
//                    style:
//                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
//                icon: Icon(
//                  FontAwesomeIcons.moneyBillAlt,
//                  size: 18,
//                ),
//              )
//            ],
//          ),
//        ),
//        body: TabBarView(
//          children: <Widget>[WithdrawMoney(), TransactionsPage()],
//        ),
//      ),
//    );
//  }
//}
