import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/app_state_manager.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:fluttercurr/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CurrencyPageViewModel extends BaseViewModel{
  late CurrencyProvider currencyProvider;
  String baseCurrency = 'USD';
  User? user;
  void onReady(BuildContext context) async{
    appContext = context;
    currencyProvider = Provider.of<CurrencyProvider>(context,listen: false);
    user = Provider.of<UserProvider>(context,listen: false).user;
    if(user == null){
      Provider.of<AppStateManager>(context,listen: false).loggedIn = false;
    }
    if(currencyProvider.currencies.isEmpty){
      await currencyProvider.fetchCurrencies();
    }

  }
}