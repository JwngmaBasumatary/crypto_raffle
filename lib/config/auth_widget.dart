
import 'package:crypto_raffle/screens/onboarding_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_raffle/screens/home_page.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<User>? userSnapshot;

  const AuthWidget({Key? key, this.userSnapshot}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    debugPrint(userSnapshot?.connectionState.toString());
    if (userSnapshot?.connectionState == ConnectionState.active) {
      return userSnapshot!.hasData ? const HomePage() : const OnBoardingPage();
    }
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    ));
  }
}
