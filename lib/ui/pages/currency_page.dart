import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:fluttercurr/ui/page_models/cur_view_model.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class CurrencyDashboard extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.authPage,
      key: ValueKey(AppPages.authPage),
      child: const CurrencyDashboard(),
    );
  }

  const CurrencyDashboard({Key? key}) : super(key: key);

  @override
  _CurrencyDashboardState createState() => _CurrencyDashboardState();
}

class _CurrencyDashboardState extends State<CurrencyDashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<CurrencyPageViewModel>(
        model: CurrencyPageViewModel(),
        onModelReady: (model) => model.onReady(context),
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.blue.withOpacity(.3),
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Current Exchange'),
            ),
            body: Container(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.15,
                      child: Column(
                        children: [
                          Center(
                            child: Text(model.user?.displayName ?? 'guest'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Base Currency: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  model.baseCurrency!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          model.displayCurrs(2);
                                        },
                                        color: Colors.white.withOpacity(0.3),
                                        icon: const Icon(Icons.edit)),
                                    const SizedBox(width: 5,),
                                    IconButton(
                                        onPressed: model.currencyProvider.fetchExchangeRate,
                                        color: Colors.white.withOpacity(0.3),
                                        icon: const Icon(Icons.refresh))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.45,
                      child: Consumer<CurrencyProvider>(
                        builder: (context,cProvider,_){
                          return cProvider.sExCurrencies.isEmpty ? const Center(
                            child: Text('No exchange data for currency selected yet'),
                          ):
                          Column(
                            children: [
                              Flexible(
                                flex:3,
                                child: TextFormField(
                                  onChanged: cProvider.searchExchange,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter search queries here'
                                  ),
                                ),
                              ),
                              Flexible(
                                flex:7,
                                child: ListView(
                                  children: cProvider.sExCurrencies.keys.map((element) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('1 ${cProvider.baseCurrency} :'),
                                          Text(cProvider.sExCurrencies[element].toString()+' $element',
                                            style: const TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.25,
                      child: Column(
                        children:  [
                          Text('Currency Converter',style: TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8)
                          ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    model.displayCurrs(0);
                                  },
                                  child: Text(model.toConvert),
                                ),
                                InkWell(
                                  onTap: model.switchCurr,
                                  child: const Icon(Icons.compare_arrows_sharp),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    model.displayCurrs(1);
                                  },
                                  child: Text(model.convertedTo),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Divider(color: Colors.tealAccent,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(model.convert().toString()),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
