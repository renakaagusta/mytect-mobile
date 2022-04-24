import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  IconData icon;
  String hint;
  String errorText;
  bool isObscure;
  bool isIcon;
  TextInputType inputType;
  TextEditingController textController;
  EdgeInsets padding;
  Color hintColor;
  Color iconColor;
  FocusNode focusNode;
  ValueChanged onFieldSubmitted;
  ValueChanged onChanged;
  bool autoFocus;
  TextInputAction inputAction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
          controller: textController,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          autofocus: autoFocus,
          textInputAction: inputAction,
          obscureText: this.isObscure,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            hintText: this.hint,
            fillColor: Colors.white,
            enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(40.0),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(40.0),
                borderSide: BorderSide(color: Color(0xffFF5400))),
          )),
    );
  }

  TextFieldWidget({
    this.icon,
    this.errorText,
    this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
  });
}
