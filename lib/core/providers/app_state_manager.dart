import 'package:flutter/cupertino.dart';

class AppStateManager extends ChangeNotifier{
  bool _isInitialized = false;
  bool _loggedIn = false;

  bool get initialized => _isInitialized;
  bool get loggedIn => _loggedIn;

  set loggedIn(bool v){
    _loggedIn = v;
    notifyListeners();
  }
  set initialized(bool v){
    _isInitialized = v;
    notifyListeners();
  }

}