import 'package:crypto_raffle/models/coinbase_commerce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalPaymentPage extends StatefulWidget {
  final CoinbaseCommerce coinbaseCommerce;

  const FinalPaymentPage({Key? key, required this.coinbaseCommerce}) : super(key: key);

  @override
  _FinalPaymentPageState createState() => _FinalPaymentPageState();
}

class _FinalPaymentPageState extends State<FinalPaymentPage> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coinbaseCommerce.metadata!.title!)
        // title: Text(widget.coinbaseCommerce.metadata.title!)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "This is the Payment Link\n ${widget.coinbaseCommerce.hostedUrl}",
            textAlign: TextAlign.center,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _launchURL(widget.coinbaseCommerce.hostedUrl!);
                },
                child: const Text("Proceed payment")),
          ),
        ],
      ),
    );
  }
}
