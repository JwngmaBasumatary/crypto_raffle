import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/widgets/notification_dialog_with_ok.dart';
import 'package:crypto_raffle/widgets/show_loading.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Stream stream;
  FirestoreServices fireStoreServices = FirestoreServices();
  bool showLoading = true;
  //



  showInterstitialAds() {
    //
  }
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //
    fireStoreServices.getNotifications().then((val) {
      setState(() {
        stream = val;
        showLoading = false;
      });
    });

    super.initState();
  }

  showNotificationDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (context) => NotificationDialogWithOk(
          title: title,
          description: message,
          primaryButtonText: "Ok",
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          StreamBuilder(
                              stream: stream,
                              builder: (context, snapshots) {
                                return snapshots.data == null
                                    ? showLoadingDialog()
                                    : ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount:
                                    snapshots.data.docs.length,
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      if (index < 0) {
                                        return const Text("No Notifications");
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          showNotificationDialog(
                                              snapshots
                                                  .data
                                                  .docs[index]
                                                  ["title"],
                                              snapshots
                                                  .data
                                                  .docs[index]
                                                  ["message"]);
                                        },
                                        child: Card(
                                          elevation: 1,
                                          color: Colors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                radius: 20,
                                                child: Icon(
                                                  Icons.announcement,
                                                  size: 15,
                                                ),
                                              ),
                                              title: AutoSizeText(
                                                snapshots
                                                    .data
                                                    .docs[index]
                                                    ["title"],
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                snapshots
                                                    .data
                                                    .docs[index]
                                                    ["message"],
                                                style:
                                                const TextStyle(fontSize: 14),
                                              ),
                                              trailing: Text(
                                                DateFormat.yMd().format(DateTime.parse(snapshots.data.docs[index]['time'].toString())),
                                                style:
                                                const TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              })
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
          showLoading ? showLoadingDialog() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
