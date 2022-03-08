import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';

class ReferUsersCustomDialog extends StatelessWidget {
  final String title, description, primaryButtonText, sharetext;
  final int referralPrize;

  static const double padding = 20.0;
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);

  const ReferUsersCustomDialog({
    Key key,
    @required this.title,
    @required this.description,
    @required this.primaryButtonText,
    @required this.sharetext,
    this.referralPrize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(0.0, 10))
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  AutoSizeText(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: primaryColor, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: sharetext == ""
                          ? ""
                          : 'Your Invitation Link for ${Constants.coinName} Faucet App \n\n',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: description,
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: sharetext == "" ? 22 : null,
                              decoration: sharetext == ""
                                  ? null
                                  : TextDecoration.underline),
                        ),
                        TextSpan(
                          text: sharetext == ""
                              ? ""
                              : '\n\nYou will be rewarded $referralPrize% of withdrawal amount lifetime per successful referral joining throught this link',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),

                      child: AutoSizeText(
                        primaryButtonText,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w200),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();

                        if (sharetext != "") {
                          Share.share(
                            sharetext,
                          );
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
