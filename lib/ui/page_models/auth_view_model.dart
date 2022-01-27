import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/app_state_manager.dart';
import 'package:fluttercurr/core/providers/user_provider.dart';
import 'package:fluttercurr/core/utils/auth.dart';
import 'package:provider/provider.dart';

class AuthenticationViewModel extends BaseViewModel{
  late UserProvider userProvider;
  bool _initialized = false;
  bool get initialized => _initialized;
  set initialized(bool v){
    _initialized = v;
    notifyListeners();
  }
  Future<void> onReady(BuildContext context) async {
    appContext = context;
    userProvider = Provider.of<UserProvider>(context,listen: false);
    User? user = await Authentication.initialize();
    if(user != null){
      userProvider.user = user;
      Provider.of<AppStateManager>(context,listen: false).loggedIn = true;
    }
    initialized = true;
  }
  Future<void> signInWithEmail()async{
    await Authentication.signinWithEmail(email: 'hello@helloworld.com', password: 'password');
  }
  Future<void> signInWithGoogle()async{
    await Authentication.loginWithGoogle();
  }
  Future<void> signInWithTwitter()async{
    await Authentication.signInWithTwitter();
  }
}