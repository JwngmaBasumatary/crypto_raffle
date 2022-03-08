import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:crypto_raffle/utils/constants.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: Lottie.asset(
                Constants.noInternet,
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ),
            const Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "You are not connected to the internet. Make sure Wi-Fi is on or Mobile data is on, Airplane Mode is Off and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, letterSpacing: 1.2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
