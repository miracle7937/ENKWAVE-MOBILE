import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/color.dart';

class CustomForm extends StatefulWidget {
  final String? setValue;
  final String? labelText, hintText, suffixText;
  final bool? forPassword, enable;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor,
      inputTextColor,
      focusedBorderColor,
      enabledBorderColor,
      disabledBorderColor,
      labelColor,
      border;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon, suffixWidget, peffixIcon;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final VoidCallback? callback;

  const CustomForm(
      {Key? key,
      this.enable = true,
      this.labelText,
      this.hintText,
      this.forPassword = false,
      this.padding,
      this.fillColor,
      this.contentPadding,
      this.onChange,
      this.suffixIcon,
      this.inputFormatters,
      this.keyboardType,
      this.controller,
      this.inputTextColor,
      this.focusedBorderColor,
      this.enabledBorderColor,
      this.labelColor,
      this.hintStyle,
      this.disabledBorderColor,
      this.suffixText,
      this.border,
      this.suffixWidget,
      this.peffixIcon,
      this.callback,
      this.setValue = ""})
      : super(key: key);

  @override
  _SYFormState createState() => _SYFormState();
}

class _SYFormState extends State<CustomForm> {
  bool showPassword = true;

  TextEditingController? controller;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    controller!.text = widget.setValue!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ??
            const EdgeInsets.symmetric(
              vertical: 10,
            ),
        child: InkWell(
          onTap: widget.callback,
          child: SizedBox(
            height: 40,
            child: TextFormField(
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              controller: controller,
              enabled: widget.enable,
              onChanged: widget.onChange,
              cursorColor: EPColors.appMainColor,
              obscureText: widget.forPassword! && showPassword,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: EPColors.appBlackColor),
              decoration: InputDecoration(
                  prefixIcon: widget.peffixIcon,
                  suffixIcon: widget.suffixWidget,
                  suffixText: widget.suffixText,
                  contentPadding:
                      widget.contentPadding ?? const EdgeInsets.all(15),
                  fillColor: widget.fillColor ?? EPColors.appWhiteColor,
                  filled: true,
                  suffix: widget.forPassword!
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: showPassword
                              ? Icon(
                                  Icons.visibility_off,
                                  color: EPColors.appMainColor,
                                  size: 15,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: EPColors.appMainColor,
                                  size: 15,
                                ))
                      : (widget.suffixIcon),
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  labelStyle: TextStyle(
                      color: widget.labelColor ?? EPColors.appMainColor),
                  hintStyle:
                      widget.hintStyle ?? const TextStyle(color: Colors.grey),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.disabledBorderColor ??
                              EPColors.appGreyColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.enabledBorderColor ??
                              const Color(0xffbfc9da))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: EPColors.appGreyColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.focusedBorderColor ??
                              EPColors.appMainColor))),
            ),
          ),
        ));
  }
}
