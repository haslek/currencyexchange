import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:fluttercurr/ui/components/app_drop_down.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryViewModel extends BaseViewModel{
  late CurrencyProvider currencyProvider;

  List<DropDownValue> currDrop = [];
  late DropDownValue currChosen;
  String? _currency;
  String? get currency => _currency;
  set currency(String? d){
    _currency = d;
    notifyListeners();
  }

  String _date = '';
  String get date => _date;
  set date(String d){
    _date = d;
    notifyListeners();
  }
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime val) {
    _selectedDate = val;
    notifyListeners();
  }

  DateFormat f = DateFormat('y-MM-dd');
  void selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: appContext!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1800),
        // lastDate: DateTime(no18Year),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primaryColor: Colors.white,
              colorScheme: const ColorScheme.light(primary: Colors.white),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: Container(
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: child,
            ),
          );
        });
    if (picked != null && picked != selectedDate) selectedDate = picked;
    date = f.format(selectedDate);
    currencyProvider.fetchHistoricalData(date,curr: currChosen.value);
  }
  void onCurrencyChange(DropDownValue v)async{
    currChosen = v;
    currencyProvider.fetchHistoricalData(date,curr: currChosen.value);
  }
  void onReady(BuildContext context)async{
    appContext = context;
    currencyProvider = Provider.of<CurrencyProvider>(context,listen: false);
    currDrop = currencyProvider.currencies.keys.map((e) {
      var d = DropDownValue(label: e,value: e);
      if(e == currencyProvider.baseCurrency){
        currChosen = d;
      }
      return d;
    }).toList();
    date = f.format(selectedDate);
    await currencyProvider.fetchHistoricalData(date,curr: currChosen.value);
  }
}