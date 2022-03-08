import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/widgets/shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class TopUsersPage extends StatefulWidget {
  const TopUsersPage({Key? key}) : super(key: key);

  @override
  _TopUsersPageState createState() => _TopUsersPageState();
}

class _TopUsersPageState extends State<TopUsersPage> {
  FirestoreServices fireStoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();
  String currentUid = "";

  bool _loadingProducts = true;
  List<DocumentSnapshot> _listUsers = [];

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    getCurrentUserId();
    getTop100Users();
  }

  getCurrentUserId() async {
    currentUid = await fireStoreServices.getCurrentUid();
  }

  getTop100Users() {
    fireStoreServices.getTopUsers().then((val) {
      _listUsers = val;
      debugPrint(_listUsers.length.toString());
      if (mounted) {
        setState(() {
          _loadingProducts = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Top 50 users"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    child: _loadingProducts == true
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.white,
                              enabled: true,
                              child: shimmerWidget(),
                            ),
                          )
                        : _listUsers.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      Constants.weeklyIcon,
                                      height: 100,
                                      width: 100,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text(
                                      "No Users yet",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _listUsers.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _listUsers[index].get("uid") ==
                                                currentUid
                                            ? Colors.red
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: CircleAvatar(
                                              radius: 20,
                                              child: Text("${index + 1}"),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: ListTile(
                                              trailing: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    color: Colors.indigo),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      "${_listUsers[index].get("profilePhoto")}"),
                                                ),
                                              ),
                                              title: Text.rich(TextSpan(
                                                  text: _listUsers[index]
                                                      .get("name"),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            " (${_listUsers[index].get("country")})",
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            color:
                                                                Colors.black54))
                                                  ])),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  "${(_listUsers[index].get("points") * Constants.decimal).toStringAsFixed(Constants.decimalLength)}"
                                                  "  ${Constants.coinName}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
              ],
            ),
          ),
        ));
  }
}
