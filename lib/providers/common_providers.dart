import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_raffle/models/users.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:flutter/material.dart';

class CommonProviders with ChangeNotifier {
  bool _isLoading = false;
  bool _btnenabled = false;
  bool _weeklyParticipated = false;
  var _loginError = "";
  bool? _isonline;

  CommonProviders() {
    _isonline = false;
    _weeklyParticipated = false;
  }

  bool get isLoading => _isLoading;

  bool get btnenabled => _btnenabled;

  bool get weeklyParticipated => _weeklyParticipated;

  String get loginError => _loginError;

  bool? get isonline => _isonline;

  void setOnline(bool value) {
    _isonline = value;
    notifyListeners();
  }

  void setWeeklyParticipated(bool value) {
    _weeklyParticipated = value;
    notifyListeners();
  }

  void setIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setLoginError(String error) {
    _loginError = error;
    notifyListeners();
  }

  void setBtnEnabled(bool enabled) {
    _btnenabled = enabled;
    notifyListeners();
  }

  final _userSnapShot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 15;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  bool get isFetchingUsers => _isFetchingUsers;

  List<Users> get users => _userSnapShot.map((DocumentSnapshot snap) {
    final user = snap;

    debugPrint('snap $snap');
    return Users(name: user["name"]);
  }).toList();

  // Future fetchNextUsers() async {
  //   debugPrint('fetchNextUsers');
  //   _errorMessage = "";
  //   _isFetchingUsers = true;
  //   try {
  //     final snap = await FirestoreServices.getNewTopUsers(10,
  //         startAfter: _userSnapShot.isNotEmpty ? _userSnapShot.last : null);
  //     _userSnapShot.addAll(snap.docs);
  //     if (snap.docs.length < documentLimit) _hasNext = false;
  //     debugPrint('snap $snap');
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint('error $error');
  //     _errorMessage = error.toString();
  //     notifyListeners();
  //   }
  //
  //   _isFetchingUsers = false;
  // }
}