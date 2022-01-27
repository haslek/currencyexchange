import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttercurr/core/utils/api_call.dart';

class CurrencyProvider extends ChangeNotifier{
  Map<String,String> _allCurrencies = {};
  Map<String,String> get currencies => _allCurrencies;
  set currencies(Map<String,String> c){
    _allCurrencies = c;
    notifyListeners();
  }
  String _baseCurrency = 'USD';
  String get baseCurrency => _baseCurrency;
  set baseCurrency(String c){
    _baseCurrency = c;
    notifyListeners();
  }
  Future<void> fetchCurrencies()async{
    String url = 'https://openexchangerates.org/api/currencies.json';
    Map response = await APIManager.getAPICall(url: url);
    // print('currencies: $response');
    if(response['status']){
      currencies = response['data'];
    }
  }
  Future<void> fetchExchangeRate()async{
    String apiKey = dotenv.env['FREECURAPI']!;
    String url = 'https://freecurrencyapi.net/api/v2/latest?apikey=$apiKey&base_currency=$_baseCurrency';
    print('url: $url');
    Map response = await APIManager.getAPICall(url: url);
    print('exchange rates: $response');
    // if(response['status']){
    //   currencies = response['data'];
    // }
  }
}