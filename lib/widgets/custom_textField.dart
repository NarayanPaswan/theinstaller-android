import 'package:flutter/material.dart';


class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget(
      {required this.labelText, this.icon, this.onClick,this.keyBoadType, this.controller, this.Enable,this.initiolValue,this.onchanged,this.vlodator});

  String labelText;
  var icon;
  bool? Enable;
  TextEditingController? controller;
  VoidCallback? onClick;
  var initiolValue;
  var onchanged;
  var vlodator;
  var keyBoadType;
  // void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      // width: width(context) * 0.95,
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.blueAccent,
          ),
        ),
        child: TextFormField(
          validator: vlodator,
          onChanged: onchanged,
          initialValue: initiolValue,
          enabled: Enable ,
          onTap: onClick,
          controller: controller,
          // onChanged:(String){ onChanged},
          keyboardType: keyBoadType,
          decoration: InputDecoration(
            border: const OutlineInputBorder(

                borderRadius: BorderRadius.all(Radius.circular(10))),
            suffixIcon: icon,
            // labelText: labelText,
            hintText: labelText,
            // labelStyle: bodyText14w600(color: primarhy),

            focusColor: Colors.blueAccent,

            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26, width: 1.0),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.only(
              left: 20,
            ),
          ),
        ),
      ),
    );
  }
}
