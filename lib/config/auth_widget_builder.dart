import 'package:crypto_raffle/screens/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_raffle/providers/all_notifiers.dart';
import 'package:crypto_raffle/providers/connectivity_provider.dart';
import 'package:crypto_raffle/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';


class AuthWidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  const AuthWidgetBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Auth Widget Builder");
    final authServices = FirebaseAuthServices();
    FirestoreServices firestoreServices = FirestoreServices();

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return StreamBuilder<User>(
            stream: authServices?.onAuthStateChanged,
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user != null) {
                return MultiProvider(
                  providers: [
                    Provider<User>.value(
                      value: user,
                    ),
                    Provider<FirestoreServices>(
                      create: (_) => FirestoreServices(),
                    ),
                    Provider<AllNotifier>(
                      create: (_) => AllNotifier(),
                    ),
                    Provider<AllNotifier>(
                      create: (_) => AllNotifier(),
                      child: const SignUpPage(),
                    ),
                    ChangeNotifierProvider<AllNotifier>(
                      create: (context) => AllNotifier(),
                      child: const SignUpPage(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => ConnectivityProvider(),
                      child: const HomePage(),
                    ),
                    StreamProvider(
                        create: (BuildContext context) =>
                            firestoreServices.getUserData(user.uid), initialData: null,),
                  ],
                  child: builder(context, snapshot),
                );
              }
              return builder(context, snapshot);
            });
      },
    );
  }
}
