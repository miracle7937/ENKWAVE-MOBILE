import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../constant/color.dart';

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
    if (widget.setValue != null) {
      _controller.text = widget.setValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? date = DateTime(1900);
        date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.light(
                  primary: EPColors.appMainColor,
                  onPrimary: Colors.white,
                  surface: EPColors.appMainColor,
                  onSurface: EPColors.appBlackColor,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );

        // = date.toIso8601String();
        if (date != null) {
          _controller.text = DateFormat('yyyy-MM-dd').format(date);
          print(date);
          widget.onChange!(_controller.text);
        }
      },
      child: Padding(
        padding: widget.padding ??
            const EdgeInsets.symmetric(
              vertical: 1,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: widget.inputTextColor ?? EPColors.appBlackColor),
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
