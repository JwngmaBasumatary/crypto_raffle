import 'dart:math';

import 'package:crypto_raffle/screens/signup_page.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: Constants.titleOne,
              body: Constants.bodyOne,
              image: buildImage(Constants.welcomeIcon),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: Constants.titleTwo,
              body: Constants.bodyTwo,
              image: buildImage(Constants.supportIcon),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: Constants.titleThree,
              body: Constants.bodyThree,
              image: buildImage(Constants.bonusIcon),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: Constants.titleFour,
              body: Constants.bodyFour,
              footer: ButtonWidget(
                text: 'Start Earning',
                onClicked: () => goToHome(context),
              ),
              image: buildImage(Constants.walletIcon),
              decoration: getPageDecoration(),
            ),
          ],
          done: const Text('Start',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(color: Colors.red),
          ),
          onSkip: () => goToHome(context),
          next: const Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => debugPrint('Page $index selected'),
          globalBackgroundColor: Theme.of(context).primaryColor,
          skipFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignUpPage()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Colors.black,
        //activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
        bodyTextStyle: const TextStyle(fontSize: 20),
        descriptionPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Tools.multiColors[Random().nextInt(4)],
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onPressed: onClicked,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
}
