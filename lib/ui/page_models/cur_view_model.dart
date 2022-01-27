import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/app_state_manager.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:fluttercurr/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CurrencyPageViewModel extends BaseViewModel{
  late CurrencyProvider currencyProvider;
  String? _baseCurrency;
  String? get baseCurrency => _baseCurrency;
  set baseCurrency(String? v){
    _baseCurrency = v;
    notifyListeners();
  }
  User? user;
  void onReady(BuildContext context) async{
    appContext = context;
    currencyProvider = Provider.of<CurrencyProvider>(context,listen: false);
    baseCurrency = currencyProvider.baseCurrency;
    user = Provider.of<UserProvider>(context,listen: false).user;
    if(user == null){
      Provider.of<AppStateManager>(context,listen: false).loggedIn = false;
    }
    if(currencyProvider.currencies.isEmpty){
      await currencyProvider.fetchCurrencies();
    }

    if(currencyProvider.exchangeRates.isEmpty){
      await currencyProvider.fetchExchangeRate();
    }
  }
  void displayCurrs()async{
    await showDialog(context: appContext!,
        useRootNavigator: false,
        builder: (context)=>Consumer<CurrencyProvider>(
          builder: (context,cProvider,_) {
            return cProvider.loading ? CircularProgressIndicator(): SimpleDialog(
      title: Column(
            children: [
              const Text('Select base currency'),
              TextFormField(
                onChanged: cProvider.search,
                decoration: const InputDecoration(
                  hintText: 'Enter search queries here'
                ),
              )
            ],
      ),
      children: cProvider.sCurrencies.keys.map<SimpleDialogOption>((key) => SimpleDialogOption(
            onPressed: (){
              cProvider.baseCurrency = key;
              baseCurrency = key;
              cProvider.sCurrencies = cProvider.currencies;
              Navigator.of(appContext!).pop();
            },
            child: Row(
              children: [
                Text(key),
                const SizedBox(width: 20,),
                Flexible(child: Text(cProvider.sCurrencies[key] ?? 'N/A',softWrap: true,))
              ],
            ),
      )).toList(),
    );
          }
        ));
  }
}