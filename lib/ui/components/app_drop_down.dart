import 'package:flutter/material.dart';

Widget buildDropDown(BuildContext context,List<DropDownValue> options,String? label,DropDownValue initVal,Function onchange, double width,{bool pad = false,bool imageLabel = false}){
  return  Padding(
    padding: !pad ? const EdgeInsets.all(1): const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null ? const SizedBox() : Container(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 50,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          margin: const EdgeInsets.only( top: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
          ),
          child: DropdownButtonFormField<DropDownValue>(
            isExpanded: true,
            decoration: InputDecoration.collapsed(
              hintText: initVal.label,
              hintStyle: Theme.of(context).textTheme.headline6,
            ),
            value: initVal,
            items: options.map((DropDownValue e)
            {
              return DropdownMenuItem<DropDownValue>(
                  value: e,
                  child: Text(e.label,
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,)
              );
            }).toList(),
            onChanged: (val){
              onchange(val);
            },
          ),
        ),
      ],
    ),
  );
}

class DropDownValue {
  final String label;
  final dynamic value;
  DropDownValue({required this.label,this.value});
}