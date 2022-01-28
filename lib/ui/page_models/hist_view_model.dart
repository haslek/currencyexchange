import 'package:flutter/cupertino.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';

class HistoryViewModel extends BaseViewModel{
  late CurrencyProvider currencyProvider;
  void onReady(BuildContext context)async{
    appContext = context;
    currencyProvider = Provider.of<CurrencyProvider>(context,listen: false);
    await currencyProvider.fetchHistoricalData();
  }
}