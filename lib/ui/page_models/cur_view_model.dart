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
  String _toConvert = '';
  String get toConvert => _toConvert;
  set toConvert(String v){
    _toConvert = v;
    notifyListeners();
  }
  String _convertedTo = '';
  String get convertedTo => _convertedTo;
  set convertedTo(String v){
    _convertedTo = v;
    notifyListeners();
  }
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
    convertedTo = toConvert =baseCurrency!;
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
  void switchCurr(){
    String tempHolder = _toConvert;
    _toConvert = _convertedTo;
    _convertedTo = tempHolder;
    notifyListeners();
  }
  double convert(){
    if(toConvert == convertedTo){
      return 1;
    }
    if(currencyProvider.exchangeRates.isEmpty ||
        currencyProvider.exchangeRates[toConvert] == null ||
        currencyProvider.exchangeRates[convertedTo] == null
    ){
      if(toConvert == baseCurrency && currencyProvider.exchangeRates[convertedTo] != null){
        return currencyProvider.exchangeRates[convertedTo];
      }
      if(convertedTo == baseCurrency && currencyProvider.exchangeRates[toConvert] != null){
        return 1/currencyProvider.exchangeRates[toConvert];
      }
      return 0;
    }
    double tRate = currencyProvider.exchangeRates[toConvert];
    double cRate = currencyProvider.exchangeRates[convertedTo];
    return tRate/cRate;
  }
  void displayCurrs(int whichField)async{
    await showDialog(context: appContext!,
        useRootNavigator: false,
        builder: (context)=>Consumer<CurrencyProvider>(
          builder: (context,cProvider,_) {
            return cProvider.loading ? const CircularProgressIndicator(): SimpleDialog(
      title: Column(
            children: [
              const Text('Select currency'),
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
              switch(whichField){
                case 0:
                  toConvert = key;
                  break;
                case 1:
                  convertedTo = key;
                  break;
                default:
                  cProvider.baseCurrency = key;
                  baseCurrency = key;
                  break;
              }
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