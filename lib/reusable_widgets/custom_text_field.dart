import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {Key key,
      this.controller,
      this.hintText,
      this.inputType,
      this.prefixIcon,
      this.textAlignCenter,
      this.autoFocus,
      this.enableSuggestions,
      this.autoCorrect,
      this.showSuffix,
      this.obscureText,
      this.isEnabled,
      this.maxLines})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final Icon prefixIcon;
  final bool textAlignCenter;
  final bool autoFocus;
  final bool enableSuggestions;
  final bool autoCorrect;
  final bool showSuffix;
  final bool obscureText;
  final bool isEnabled;
  final int maxLines;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnabled!=null?widget.isEnabled:true,
      autofocus: widget.autoFocus != null && widget.autoFocus == true
          ? widget.autoFocus : false,
      controller: widget.controller != null ? widget.controller : null,
      keyboardType:
          widget.inputType != null ? widget.inputType : TextInputType.text,
      maxLines: widget.maxLines!=null?widget.maxLines:1,
      obscureText: widget.obscureText != null && widget.obscureText == true
          ? _obscureText
          : false,
      enableSuggestions:
          widget.enableSuggestions != null ? widget.enableSuggestions : true,
      autocorrect: widget.autoCorrect != null ? widget.autoCorrect : true,
      textAlign:
          widget.textAlignCenter != null && widget.textAlignCenter == true
              ? TextAlign.center
              : TextAlign.start,
      decoration: InputDecoration(
        suffixIcon: widget.showSuffix == true
            ? TextButton(
                child: Text(
                  _obscureText ? 'Show' : 'Hide',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  _toggle();
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white70.withOpacity(.5),
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.white24)
            //borderSide: const BorderSide(),
            ),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: widget.hintText,
        // hintStyle: TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }
}
