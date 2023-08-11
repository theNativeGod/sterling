import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    this.style,
    this.readOnly,
    this.onTap,
    this.textAlign,
    this.onEditingComplete,
    this.validator,
    required this.controller,
    required this.headingText,
    required this.hintText,
    required this.textInputType,
    super.key,
  });
  var style;
  var readOnly;
  var onTap;
  var textAlign;
  var onEditingComplete;
  var validator;
  final TextEditingController controller;
  final String headingText;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 42,
          // height: 50,
          decoration: BoxDecoration(
            color: headingText == 'Code*' ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            onTap: onTap ?? null,
            textAlign: textAlign ?? TextAlign.left,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onEditingComplete: onEditingComplete,
            validator: validator,
            style: TextStyle(
                color: headingText == 'Code*' ? Colors.white : Colors.black),
            controller: controller,
            keyboardType: textInputType,
            cursorColor: Theme.of(context).primaryColor,
            readOnly: headingText == 'Code*' ? true : false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 16,
              ),
              //prefixIconConstraints: BoxConstraints(minWidth: 10),
              // prefixIcon: headingText != 'Code'
              //     ? SizedBox(
              //         width: 0,
              //       )
              //     : CountryCodePicker(
              //         //it is used to find country code and flage symbol
              //         padding: EdgeInsets.zero,
              //         alignLeft: true,
              //         hideMainText: true,
              //         onChanged: (country) {
              //           controller.text = country.dialCode!;
              //         },

              //         flagWidth: 30,
              //         initialSelection: "IN", //default is it
              //         showCountryOnly: true,
              //         showOnlyCountryWhenClosed: false,
              //       ),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xfff4f4f4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
