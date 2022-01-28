import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/app_state_manager.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:fluttercurr/core/providers/user_provider.dart';
import 'package:fluttercurr/core/utils/auth.dart';
import 'package:provider/provider.dart';

class CurrencyPageViewModel extends BaseViewModel{
  late CurrencyProvider currencyProvider;
  String? _baseCurrency;
  String _toConvert = '';
  String get toConvert => _toConvert;
  TextEditingController amountController = TextEditingController(text: '0');
  set toConvert(String v){
    _toConvert = v;
    notifyListeners();
  }
  String _amountText = '0';
  String get amountText => _amountText;
  set amountText(String v){
    _amountText = v;
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
    Timer.periodic(const Duration(minutes: 5), (timer)async {
      await currencyProvider.fetchExchangeRate();
    });
    // if(currencyProvider.exchangeRates.isEmpty){
    //
    // }
  }
  Future<void> showLogoutDialog() async {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
      onPressed:  () {
        Navigator.of(appContext!).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Log Out",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
      onPressed:  signOut,
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Log Out",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      content: const Text("Are you sure to log out?"),
      backgroundColor: Colors.white,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(context: appContext!,useRootNavigator: false, builder: (context)=>alert);
  }
  void signOut()async{
    await Authentication.signOut();
    Provider.of<AppStateManager>(appContext!,listen: false).loggedIn = false;
  }
  void switchCurr(){
    String tempHolder = _toConvert;
    _toConvert = _convertedTo;
    _convertedTo = tempHolder;
    notifyListeners();
  }
  double convert(){
    double amount = double.parse(amountController.text);
    if(toConvert == convertedTo){
      return amount;
    }
    if(amount == 0){
      return amount;
    }
    if(currencyProvider.exchangeRates.isEmpty ||
        currencyProvider.exchangeRates[toConvert] == null ||
        currencyProvider.exchangeRates[convertedTo] == null
    ){
      if(toConvert == baseCurrency && currencyProvider.exchangeRates[convertedTo] != null){
        return amount * currencyProvider.exchangeRates[convertedTo];
      }
      if(convertedTo == baseCurrency && currencyProvider.exchangeRates[toConvert] != null){
        return 1/(currencyProvider.exchangeRates[toConvert]* amount);
      }
      return 0;
    }
    double tRate = amount * currencyProvider.exchangeRates[toConvert];
    double cRate = currencyProvider.exchangeRates[convertedTo];
    print(amount);
    return cRate/tRate;
  }
  void displayAmountDialog()async{
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
      onPressed:  () {
        Navigator.of(appContext!).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
      onPressed:  (){
        convert();
        Navigator.pop(appContext!);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Currency Size",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      content: TextFormField(
        controller: amountController,
        keyboardType: TextInputType.number,
        onChanged: (str){
          amountText = str;
        },
      ),
      backgroundColor: Colors.white,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(context: appContext!,useRootNavigator: false, builder: (context)=>alert);
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
            onPressed: () async {
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
                  await currencyProvider.fetchExchangeRate();
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