import 'package:flutter/material.dart';

import '../constant/color.dart';

class EPButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? loading, active;
  final String? title;
  final Color? bgColor, textColor;
  const EPButton(
      {Key? key,
      this.onTap,
      this.title,
      this.loading = false,
      this.bgColor,
      this.active = true,
      this.textColor})
      : super(key: key);

  @override
  _DXButtonState createState() => _DXButtonState();
}

class _DXButtonState extends State<EPButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return EPColors.appGreyColor;
            }
            return widget.bgColor ??
                (widget.active!
                    ? EPColors.appMainColor
                    : EPColors.appGreyColor);
          }),
        ),
        // splashColor: Colors.red,
        onPressed: () => (widget.loading ?? false) ? null : widget.onTap!(),
        child: SizedBox(
          height: 55,
          child: Center(
              child: (widget.loading ?? false)
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    )
                  : Text(
                      widget.title ?? "",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: widget.textColor ?? Colors.white),
                    )),
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(6.0),
          //     color:),
        ),
      ),
    );
  }
}
