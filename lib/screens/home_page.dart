import 'dart:async';
import 'package:crypto_raffle/dashboard_screens/results_page.dart';
import 'package:crypto_raffle/dashboard_screens/tickets_page.dart';
import 'package:crypto_raffle/dashboard_screens/account_page.dart';
import 'package:crypto_raffle/services/remote_config_ervices.dart';
import 'package:crypto_raffle/widgets/custom_animated_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:crypto_raffle/providers/connectivity_provider.dart';
import 'package:crypto_raffle/screens/no_internet.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crypto_raffle/widgets/message_dialog_with_ok.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dashboard_screens/home_screen.dart';
import 'about_us.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const playStoreUrl = Constants.appLink;
  FirestoreServices fireStoreServices = FirestoreServices();

  var selectedIndex = 0;

  @override
  void initState() {
    try {
      versionCheck(context);
    } catch (e) {
      debugPrint(e.toString());
    }
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      debugPrint("onMessage: $event");

      showDialog(
          context: context,
          builder: (context) => CustomDialogWithOk(
                title: event.notification!.body!,
                description: event.notification!.body!,
                primaryButtonText: "Ok",
                primaryButtonRoute: HomePage.routeName,
              ));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("onLaunch: $message");
      _navigateToItemDetail(message);
    });
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //PRIVATE METHOD TO HANDLE NAVIGATION TO SPECIFIC PAGE
  void _navigateToItemDetail(message) {
    final MessageBean item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);

    if (item.itemId != "1") {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const HomePage();
      }));
    }

    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  versionCheck(context) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    var remoteConfig = RemoteConfigServices();
    var latestVersion = await remoteConfig.checkLatestVersion();
    try {
      var newVersion = latestVersion.trim().replaceAll(".", "");

      if (double.parse(newVersion) > currentVersion) {
        _showVersionDialog(context);
      }
    } on PlatformException catch (exception) {
      debugPrint(exception.toString());
    } catch (exception) {
      debugPrint(
          'Unable to fetch remote config, cached data will be used in homePage');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available, We only consider claims from our latest version app. please update it now.";
        String btnLabel = "Update Now";
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(playStoreUrl),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return pageUI();
  }

  final _inactiveColor = Colors.grey;
  final _appbarTitle = Constants.appName;
  List<String> appbarTitles=["Crypto Raffle",""];
  final _screens = [
    const HomeScreen(),
    const ResultsPage(),
    const AccountScreen()
  ];

  Widget pageUI() {
    // var userData = Provider.of<UserStream>(context);
    return Consumer<ConnectivityProvider>(
      builder: (consumerContext, model, child) {
        if (model.isOnline != null) {
          return model.isOnline
              ? WillPopScope(
                  onWillPop: () async{
                    return await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Exit"),
                            content:
                                const Text("Are you sure you want to exit?"),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text("YES"),
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text("NO"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text(Constants.appName),
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
                    ),
                    body: Stack(
                      children: _screens
                          .asMap()
                          .map((key, screen) => MapEntry(
                              key,
                              Offstage(
                                offstage: selectedIndex != key,
                                child: screen,
                              )))
                          .values
                          .toList(),
                    ),
                    bottomNavigationBar: CustomAnimatedBottomBar(
                      containerHeight: 70,
                      backgroundColor: Colors.white,
                      showElevation: true,
                      selectedIndex: selectedIndex,
                      itemCornerRadius: 24,
                      curve: Curves.easeIn,
                      onItemSelected: (int index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      items: <BottomNavyBarItem>[
                        BottomNavyBarItem(
                          icon: const Icon(FontAwesomeIcons.home),
                          title: const Text('Home'),
                          activeColor: Colors.green,
                          inactiveColor: _inactiveColor,
                          textAlign: TextAlign.center,
                        ),
                 /*       BottomNavyBarItem(
                          icon: const Icon(FontAwesomeIcons.ticketAlt),
                          title: const Text('Ticket'),
                          activeColor: Colors.purpleAccent,
                          inactiveColor: _inactiveColor,
                          textAlign: TextAlign.center,
                        ),*/
                        BottomNavyBarItem(
                          icon: const Icon(Icons.task_alt),
                          title: const Text(
                            'Results',
                          ),
                          activeColor: Colors.pink,
                          inactiveColor: _inactiveColor,
                          textAlign: TextAlign.center,
                        ),
                        BottomNavyBarItem(
                          icon: const Icon(FontAwesomeIcons.trophy),
                          title: const Text(
                            'Winner ',
                          ),
                          activeColor: Colors.pink,
                          inactiveColor: _inactiveColor,
                          textAlign: TextAlign.center,
                        ),
                        BottomNavyBarItem(
                          icon: const Icon(FontAwesomeIcons.tasks),
                          title: const Text('More'),
                          activeColor: Colors.blue,
                          inactiveColor: _inactiveColor,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    drawer: Drawer(
                      child: ListView(
                        children: <Widget>[
                          const UserAccountsDrawerHeader(
                            accountName: Text(
                              Constants.appName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            accountEmail: Text(
                              "Email@gmail.com",
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                            currentAccountPicture: CircleAvatar(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(Constants.appLogo),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text("Home"),
                            leading: const Icon(Icons.home),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const HomePage();
                              }));
                            },
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.indigo,
                          ),
                          ListTile(
                            title: const Text("About us"),
                            leading: const Icon(Icons.info),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AboutUsScreen();
                              }));
                            },
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.indigo,
                          ),
                          ListTile(
                            title: const Text("Logout"),
                            leading: const Icon(FontAwesomeIcons.signOutAlt),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : WillPopScope(
                  onWillPop: () async {
                    return await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Exit"),
                            content: const Text(
                                "Are you sure you want to exit? Instead You Can Switch your network On and use The App"),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text("YES"),
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text("NO"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: const NoInternet());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

/*
final Map<String, MessageBean> _items = <String, MessageBean>{};

MessageBean _itemForMessage(Map<String, dynamic> message) {
  //If the message['data'] is non-null, we will return its value, else return map message object
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final MessageBean item = _items.putIfAbsent(
      itemId, () => MessageBean(itemId: itemId))
    ..status = data['status'];
  return item;
}

//Model class to represent the message return by FCM
class MessageBean {
  MessageBean({this.itemId});

  final String itemId;

  final StreamController<MessageBean> _controller =
      StreamController<MessageBean>.broadcast();

  Stream<MessageBean> get onChanged => _controller.stream;

  String _status;

  String get status => _status;

  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};

  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(
          itemId: itemId,
        ),
      ),
    );
  }
}

//Detail UI screen that will display the content of the message return from FCM
class DetailPage extends StatefulWidget {
  final String itemId;

  const DetailPage({Key key, this.itemId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MessageBean _item;
  StreamSubscription<MessageBean> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.itemId];
    _subscription = _item.onChanged.listen((MessageBean item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _item.itemId == "1"
            ? const Text("Payment Approved")
            : const Text(""),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: CircleAvatar(
              radius: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  Constants.freeCash,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Center(
              child: Text(
            _item.status,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          )),
        ],
      ),
    );
  }

  showToasts(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
*/
