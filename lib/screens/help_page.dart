
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
class HelpPage extends StatefulWidget {
  static const String routeName = "HelpPage";

  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _subController = TextEditingController();

  final TextEditingController _messageController = TextEditingController();
  //

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //
  }



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
        title: const Text("Help "),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _subController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: "Enter The Subject"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _messageController,
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(labelText: "Enter Your Message"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_subController.text.toString() != null &&
                          _subController.text.toString() != "") {
                        FirestoreServices firestoreServices =
                            FirestoreServices();

                        String name = await firestoreServices.getName();
                        String email = await firestoreServices.getEmail();
                        String uid = await firestoreServices.getCurrentUid();
                        String appName= Constants.appName;
                        debugPrint("Uid-  $uid");
                        var emailUrl =
                            '''mailto:${Constants.email}?subject=${_subController.text.toString()}&body=${_messageController.text.toString()}\n\n\n\nName: $name,\nEmail: $email,\n App Name: $appName,\n Uid:$uid (Do not remove or edit this value, they are useful to solve your problem)''';
                        var out = Uri.encodeFull(emailUrl);
                        await _launchURL(out);
                      } else {
                        Tools.showToasts("Fill the Both Fields");
                      }
                    },
                    child: const Text(
                      "Send Message",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
