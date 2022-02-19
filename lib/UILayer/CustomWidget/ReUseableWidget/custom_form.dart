import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EPForm extends StatefulWidget {
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
  final Widget? suffixIcon, suffixWidget;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextStyle? hintStyle;

  const EPForm(
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
      this.suffixWidget})
      : super(key: key);

  @override
  _SYFormState createState() => _SYFormState();
}

class _SYFormState extends State<EPForm> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            vertical: 10,
          ),
      child: SizedBox(
        height: 49,
        child: TextFormField(
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          enabled: widget.enable,
          onChanged: widget.onChange,
          cursorColor: EPColors.appMainColor,
          obscureText: widget.forPassword! && showPassword,
          style: TextStyle(
              color: widget.inputTextColor ?? EPColors.appGreyColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              suffixIcon: widget.suffixWidget,
              suffixText: widget.suffixText,
              contentPadding: widget.contentPadding ?? const EdgeInsets.all(8),
              fillColor: widget.fillColor,
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
              labelStyle:
                  TextStyle(color: widget.labelColor ?? EPColors.appMainColor),
              hintStyle:
                  widget.hintStyle ?? const TextStyle(color: Colors.grey),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          widget.disabledBorderColor ?? EPColors.appGreyColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.enabledBorderColor ??
                          const Color(0xffbfc9da))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: EPColors.appGreyColor)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          widget.focusedBorderColor ?? EPColors.appMainColor))),
        ),
      ),
    );
  }
}

class EPDateForm extends StatefulWidget {
  final String? labelText, hintText, suffixText, setValue;
  final bool? forPassword, enable, changeFormat;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor, inputTextColor;
  final EdgeInsetsGeometry? contentPadding;
  final Icon? suffixIcon;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? conversionText, title;
  final Color? focusedBorderColor, enabledBorderColor, disabledBorderColor;

  const EPDateForm(
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
      this.suffixText,
      this.conversionText,
      this.focusedBorderColor,
      this.enabledBorderColor,
      this.disabledBorderColor,
      this.title,
      this.setValue,
      this.changeFormat = true})
      : super(key: key);

  @override
  _CXDateFormState createState() => _CXDateFormState();
}

class _CXDateFormState extends State<EPDateForm> {
  bool showPassword = true;
  final _controller = TextEditingController();

  @override
  void dispose() {
    // other dispose methods
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleText);
    // other code here
  }

  _handleText() {
    // do what you want with the text, for example:
    _controller.text = widget.setValue!;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime date = DateTime(1900);
        date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now()))!;

        // = date.toIso8601String();
        _controller.text = DateFormat('dd/MM/yyyy').format(date);

        widget.onChange!(_controller.text);
      },
      child: Padding(
        padding: widget.padding ??
            const EdgeInsets.symmetric(
              vertical: 10,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? "",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 49,
              child: TextFormField(
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.keyboardType,
                controller: widget.controller ?? _controller,
                enabled: false,
                onChanged: widget.onChange,
                cursorColor: EPColors.appMainColor,
                obscureText: widget.forPassword!,
                style: TextStyle(
                    color: widget.inputTextColor ?? Colors.black, fontSize: 12),
                decoration: InputDecoration(
                    suffixText: widget.suffixText,
                    contentPadding: widget.contentPadding,
                    fillColor: widget.fillColor,
                    // filled: true,
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    labelStyle: TextStyle(color: EPColors.appWhiteColor),
                    hintStyle: TextStyle(color: EPColors.appGreyColor),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: widget.disabledBorderColor ??
                                EPColors.appGreyColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: widget.enabledBorderColor ??
                                EPColors.appGreyColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: EPColors.appGreyColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: widget.focusedBorderColor ??
                                EPColors.appMainColor))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
