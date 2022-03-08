import 'package:crypto_raffle/services/dynamic_links_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:crypto_raffle/screens/address_page.dart';
import 'package:crypto_raffle/screens/profile_page.dart';
import 'package:crypto_raffle/screens/splash_screen_page.dart';
import 'package:provider/provider.dart';
import 'package:crypto_raffle/dashboard_screens/account_page.dart';
import 'package:crypto_raffle/screens/home_page.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'auth_widget_builder.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final DynamicServices _dynamicServices = DynamicServices();

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    await _dynamicServices.handleDynamicLinks(context);
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return Provider<FirebaseAuthServices>(
          create: (_) => FirebaseAuthServices(),
          child: AuthWidgetBuilder(builder: (context, userSnapshot) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  primaryColor: Colors.white,
                  //accentColor: Colors.green,
                ),
                routes: {
                  "/home": (context) => const HomePage(),
                  HomePage.routeName: (context) => const HomePage(),
                  "/account": (context) => const AccountScreen(),
                  AccountScreen.routeName: (context) => const AccountScreen(),
                  ProfilePage.routeName: (context) => const ProfilePage(),
                  AddressPage.routeName: (context) => const AddressPage(),
                },
                home: SplashScreenPage(userSnapshot: userSnapshot)
            );
          }),
        );
      },
    );
  }
}
