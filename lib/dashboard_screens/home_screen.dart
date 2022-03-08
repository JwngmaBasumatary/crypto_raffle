import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:crypto_raffle/widgets/ads_banner_widget.dart';
import 'package:crypto_raffle/widgets/home_event_category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool showLoading = true;
  FirestoreServices fireStoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();
  int totalUser = 0;
  String? lastNotifiedDate;
  int points = 0;

  Stream? stream;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // checkIfTodaysLeftClick();
      // getTheLiveEvents();
    });
    super.initState();
  }

  /*getTheLiveEvents() {
    fireStoreServices.getLiveEvents().then((val) {
      setState(() {
        stream = val;
        showLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getTheLiveEvents();
  }*/

/*  checkIfTodaysLeftClick() async {
    var allNotifier = Provider.of<AllNotifier>(context, listen: false);

    if (allNotifier.isonline) {
      points = await fireStoreServices.getPoints();
      getTotalUsers();
      setState(() {});
    } else {
      allNotifier.setOnline(true);
      var today = await fireStoreServices.getToday();

      if (today != DateTime.now().day) {
        fireStoreServices.addToday().then((value) async {
          points = await fireStoreServices.getPoints();
          getTotalUsers();
          setState(() {});
        });
      }
    }
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  Color containerColor = const Color(0xff9567e1);
  final colorWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    //var userData = Provider.of<UserStream>(context);
    return Scaffold(
        /*  appBar: AppBar(
          title: const Text(Constants.appName),
          automaticallyImplyLeading: false,
          elevation: 0.1,
          actions: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.envelope_open,
                size: 26,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.help_center_outlined,
                size: 26,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.bell, size: 26),
              onPressed: () {},
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),*/
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: double.infinity),
            child: Column(
              children: <Widget>[
                const AdsBannerWidget(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Join Crypto Raffle Events Daily",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const HomeEventCategoryWidget(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                    onPressed: () {
                      Tools.showToasts(
                          "Learn More Button has been Click, will redirect him to the youtube Page");
                    },
                    child: const Text(
                      "Learn More ",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    Constants.fairDrawNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
