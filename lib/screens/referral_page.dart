import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/services/dynamic_links_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/widgets/refer_users_custom_dialog.dart';
import 'package:crypto_raffle/widgets/shimmer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class ReferralPage extends StatefulWidget {
  static const String routeName = "/accountScreen";

  const ReferralPage({Key key}) : super(key: key);

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  var fireStoreServices = FirestoreServices();
  var ref = "";
  bool showLoading = true;

  bool _loadingProducts = true;
  List<DocumentSnapshot> _listEvents = [];

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getReferalId();
    getEvents();
  }

  Future getReferalId() async {
    ref = await fireStoreServices.getReferralId("referralId");
    setState(() {});
  }

  getEvents() {
    fireStoreServices.getReferredUsers().then((val) {
      _listEvents = val;
      setState(() {
        if (mounted) {
          _loadingProducts = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refer And Earn"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Refer Your Friends",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "On Every Successfull Withdrawal of your referred friend, you will receive 10% ${Constants.symbol} of the withdrawal amount",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.indigo),
                          child: Image.asset(Constants.refIcon)),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Your Referral Link-",
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.indigo),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ref == "" || ref == null
                              ? const Text("Not Generated")
                              : Text(
                                  ref,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ref == "" || ref == null
                          ? ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed: () async {
                                generateReferralLink();
                              },
                              child: const Text("Generate Referral Link"))
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.share),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                var textToShare =
                                    "Inviting you to join ${Constants.coinName} Faucet App. \n\nYou can earn Unlimited ${Constants.coinName} from this App. \n\nDownload From Play store. Link- $ref \n\nJoin us Now";
                                Share.share(textToShare);
                              },
                              label: const Text("Invite and Earn")),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("My referrals"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.refresh)),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                    : _listEvents.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const <Widget>[
                                                SizedBox(
                                                  height: 100,
                                                ),
                                                Text(
                                                  "Nothing to show here",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: _listEvents.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                elevation: 1,
                                                color: Colors.grey,
                                                child: ListTile(
                                                  leading: Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    100)),
                                                        color: Colors.indigo),
                                                    child: CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage: NetworkImage(
                                                          "${_listEvents[index].get("profilePhoto")}"),
                                                    ),
                                                  ),
                                                  title: AutoSizeText(
                                                    "${_listEvents[index].get("name")}",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    "${_listEvents[index].get("email")}",
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  trailing: Text(
                                                    DateFormat.yMd().format(
                                                        DateTime.parse(
                                                            _listEvents[index]
                                                                .get(
                                                                    'createdOn')
                                                                .toString())),
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              );
                                            })),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  generateReferralLink() async {
    DynamicServices _dynamicServices = DynamicServices();
    FirestoreServices fireStoreServices = FirestoreServices();
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: true);
    await progressDialog.show();

    _dynamicServices
        .createDynamicLinks(
      short: true,
    )
        .then((val) async {
      String linkToShare = val;
      debugPrint(" Link to Share= $linkToShare");
      fireStoreServices.setReferralLink(linkToShare).then((val) {
        progressDialog.hide();
        showDialog(
            context: context,
            builder: (context) => ReferUsersCustomDialog(
                  referralPrize: 10,
                  title: "Share With Your Friends",
                  description: " $linkToShare",
                  primaryButtonText: "Invite And Earn",
                  sharetext:
                      "Inviting you to join ${Constants.coinName} Faucet App.\n\n You can earn Unlimited ${Constants.coinName} from this App. \n\nDownload From Play store . Link- $linkToShare \n\nJoin us Now",
                )).then((value) {
          setState(() {});
        });
      });
    });
  }
}
