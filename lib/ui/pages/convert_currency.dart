import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view.dart';
import 'package:fluttercurr/ui/page_models/cur_view_model.dart';

import '../pages.dart';
class CurrencyConverterPage extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.convertPage,
      key: ValueKey(AppPages.convertPage),
      child: const CurrencyConverterPage(),
    );
  }
  const CurrencyConverterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CurrencyPageViewModel>(
      model: CurrencyPageViewModel(),
      onModelReady: (model)=>model.onReady(context),
      builder: (context,model,_) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Currency Converter'),
          ),
          backgroundColor: Colors.blue.withOpacity(.3),
          body:SingleChildScrollView(
            child: Column(
              children:  [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: model.displayAmountDialog,
                                  child: Text(model.amountText,
                                    style: TextStyle(color: Colors.white.withOpacity(0.3),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),),
                                ),
                              ),
                              const SizedBox(width: 30,),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (){
                                    model.displayCurrs(0);
                                  },
                                  child: Text(model.toConvert,
                                    style: TextStyle(color: Colors.white.withOpacity(0.3),fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: model.switchCurr,
                          child: const Icon(Icons.compare_arrows_sharp),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          model.displayCurrs(1);
                        },
                        child: Text(model.convertedTo,style: TextStyle(color: Colors.white.withOpacity(0.3),fontWeight: FontWeight.bold),),
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
                    child: Text(model.convert().toString(),
                      style:  TextStyle(color: Colors.yellowAccent.shade100,fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
