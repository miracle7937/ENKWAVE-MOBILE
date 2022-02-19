import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class EPButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? loading;
  final String? title;
  final Color? bgColor;
  const EPButton(
      {Key? key, this.onTap, this.title, this.loading = false, this.bgColor})
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
            return widget.bgColor ?? EPColors.appMainColor;
          }),
        ),
        // splashColor: Colors.red,
        onPressed: () => (widget.loading ?? false) ? null : widget.onTap!(),
        child: SizedBox(
          height: 55,
          child: Center(
              child: (widget.loading ?? false)
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                    )
                  : Text(
                      widget.title ?? "",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(6.0),
          //     color:),
        ),
      ),
    );
  }
}

class DashButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  const DashButton({Key? key, this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return EPColors.appMainColor;
            }
            return EPColors.appWhiteColor;
          }),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}

class ContainButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  const ContainButton({Key? key, this.child, this.onTap, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: child),
      decoration: BoxDecoration(
        color: EPColors.appWhiteColor,
        boxShadow: const [
          BoxShadow(
              offset: Offset(4, 4),
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 15)
        ],
        borderRadius: borderRadius ?? BorderRadius.circular(5.0),
      ),
    );
  }
}
