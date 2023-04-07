import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class EPButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? loading, active;
  final String? title;
  final Color? bgColor;
  const EPButton(
      {Key? key,
      this.onTap,
      this.title,
      this.loading = false,
      this.bgColor,
      this.active = true})
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

class EPButtonWithBoarder extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? loading, active;
  final String? title;
  final Color? bgColor;
  const EPButtonWithBoarder(
      {Key? key,
      this.onTap,
      this.title,
      this.loading = false,
      this.bgColor,
      this.active = true})
      : super(key: key);

  @override
  _EPButtonWithBoarderState createState() => _EPButtonWithBoarderState();
}

class _EPButtonWithBoarderState extends State<EPButtonWithBoarder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: EPColors.appMainColor))),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return EPColors.appGreyColor;
            }
            return widget.bgColor ??
                (widget.active!
                    ? EPColors.appWhiteColor
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
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
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
    return ElevatedButton(
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
      child: Container(
        child: child,
      ),
    );
  }
}

class ContainButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  final Color? bgColor;
  const ContainButton(
      {Key? key, this.child, this.onTap, this.borderRadius, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Center(child: child),
        decoration: BoxDecoration(
          color: bgColor ?? EPColors.appWhiteColor,
          boxShadow: const [
            BoxShadow(
                offset: Offset(4, 4),
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 15)
          ],
          borderRadius: borderRadius ?? BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
