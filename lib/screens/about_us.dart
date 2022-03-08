import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/services/remote_config_ervices.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  var currentVersion = "";

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getTheCurrentVersion();
    checkForLatestVersion();
  }

  getTheCurrentVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    currentVersion = info.version.trim();
    setState(() {});
  }

  var remoteConfig = RemoteConfigServices();
  var latestVersion = "";
  checkForLatestVersion() async {
    remoteConfig.checkLatestVersion().then((value) {
      setState(() {
        latestVersion = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    _launchTelegram(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Tools.showToasts("You Do not hyave Telegram Installed");
        throw 'Could not launch $url';
      }
    }

    Widget socialActions(context) => FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(FontAwesomeIcons.telegram),
                onPressed: () async {
                  await _launchTelegram(Constants.telegramGroupLink);
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.envelope),
                onPressed: () async {
                  FirestoreServices firestoreServices = FirestoreServices();

                  String name = await firestoreServices.getName();
                  String email = await firestoreServices.getEmail();
                  String uid = await firestoreServices.getCurrentUid();
                  String appName = Constants.appName;

                  debugPrint("Uid-  $uid");
                  var emailUrl =
                      '''mailto:${Constants.email}?subject=Support Needed For ${Constants.appName}&body=\n\n\n\n\n\n\n\n\n\n\n\n\n\nName: $name,\nEmail: $email,\nApp Name: $appName,\n Uid:$uid (Do not remove or edit this value, they are useful to solve your problem)''';
                  var out = Uri.encodeFull(emailUrl);
                  await _launchURL(out);
                },
              ),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CircleAvatar(
                  radius: 100,
                  child: Image.asset(
                    Constants.appLogo,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: AutoSizeText(
                "${Constants.appName} App",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                Constants.descAboutApp,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Your version- $currentVersion",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                " Latest Version- $latestVersion",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                Constants.contactUs,
                textAlign: TextAlign.center,
              ),
            ),
            socialActions(context),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
