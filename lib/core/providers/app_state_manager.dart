import 'package:flutter/cupertino.dart';

class AppStateManager extends ChangeNotifier{
  bool _isInitialized = false;
  bool _loggedIn = false;
  bool _history = false;
  String? _curError;

  bool get initialized => _isInitialized;
  bool get loggedIn => _loggedIn;
  bool get history => _history;
  String? get curError => _curError;

  set loggedIn(bool v){
    _loggedIn = v;
    notifyListeners();
  }
  set initialized(bool v){
    _isInitialized = v;
    notifyListeners();
  }
  set history(bool v){
    _history = v;
    notifyListeners();
  }
  set curError(String? v){
    _curError = v;
    notifyListeners();
  }

}