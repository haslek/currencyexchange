import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttercurr/core/utils/api_call.dart';

class CurrencyProvider extends ChangeNotifier{
  Map<String,dynamic> _allCurrencies = {};
  Map<String,dynamic> get currencies => _allCurrencies;

  Map<String,dynamic> _exchangeRates = {};
  Map<String,dynamic> get exchangeRates => _exchangeRates;
  set exchangeRates(Map<String,dynamic> c){
    _exchangeRates = c;
    notifyListeners();
  }
  set currencies(Map<String,dynamic> c){
    _allCurrencies = c;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool v){
    _loading = v;
    notifyListeners();
  }
  Map<String,dynamic> _searchCurrencies = {};
  Map<String,dynamic> get sCurrencies => _searchCurrencies;
  set sCurrencies(Map<String,dynamic> c){
    _searchCurrencies = c;
    notifyListeners();
  }
  Map<String,dynamic> _history = {};
  Map<String,dynamic> get history => _history;
  set history(Map<String,dynamic> c){
    _history = c;
    notifyListeners();
  }
  Map<String,dynamic> _searchExCurrencies = {};
  Map<String,dynamic> get sExCurrencies => _searchExCurrencies;
  set sExCurrencies(Map<String,dynamic> c){
    _searchExCurrencies = c;
    notifyListeners();
  }
  String _baseCurrency = 'USD';
  String get baseCurrency => _baseCurrency;
  set baseCurrency(String c){
    _baseCurrency = c;
    notifyListeners();
  }
  void search(String query){
    loading = true;
    Map<String,dynamic> res={};
    print(query);
    if(_allCurrencies.isNotEmpty){
      _allCurrencies.keys.forEach((element) {
        if(element.contains(query.toUpperCase())){
          res[element] = _allCurrencies[element];
        }
      });
      sCurrencies = res;
      loading = false;
      // print(sCurrencies);
    }
  }
  void searchExchange(String query){
    loading = true;
    Map<String,dynamic> res={};
    // print(query);
    if(_exchangeRates.isNotEmpty){
      _exchangeRates.keys.forEach((element) {
        if(element.contains(query.toUpperCase())){
          res[element] = _exchangeRates[element];
        }
      });
      sExCurrencies = res;
      loading = false;
    }
  }
  Future<void> fetchCurrencies()async{
    String url = 'https://openexchangerates.org/api/currencies.json';
    Map response = await APIManager.getAPICall(url: url);
    // print('currencies: ${response["data"] is Map<String,dynamic>}');
    if(response['status']){
      // print('hello');
      _allCurrencies = response['data'];
      _searchCurrencies = _allCurrencies;
      notifyListeners();
      // print(_allCurrencies);
    }
  }
  Future<void> fetchExchangeRate()async{
    String apiKey = dotenv.env['FREECURAPI']!;
    String url = 'https://freecurrencyapi.net/api/v2/latest?apikey=$apiKey&base_currency=$_baseCurrency';
    // print('url: $url');
    Map response = await APIManager.getAPICall(url: url);
    // print('exchange rates: $response');
    if(response['status']){
      _exchangeRates = response['data']['data'];
      _searchExCurrencies = _exchangeRates;
      notifyListeners();
    }
  }
  Future<void> fetchHistoricalData(String date,{String? curr}) async{
    curr ??= _baseCurrency;
    String apiKey = dotenv.env['FREECURAPI']!;
    String url = 'https://freecurrencyapi.net/api/v2/historical?apikey=$apiKey&base_currency=$curr&date_from=$date&date_to=$date';
    // print('url: $url');
    Map response = await APIManager.getAPICall(url: url);
    print('history rates: $response');
    if(response['status'] && response['data']!= null){
      _history = response['data']['data'][date];
    }else{
      _history = {};
    }
    notifyListeners();
  }
}