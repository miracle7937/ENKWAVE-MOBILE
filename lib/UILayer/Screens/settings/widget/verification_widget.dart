import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constant/colors.dart';

class VerificationWidget extends StatelessWidget {
  final bool? isVerifyCompleted;
  final VoidCallback? onTap;
  const VerificationWidget(
      {Key? key, this.isVerifyCompleted = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: InkWell(
        onTap: isVerifyCompleted == true ? null : onTap,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  isVerifyCompleted == true
                      ? "Account has been verify"
                      : "Tap to Verify your account",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: EPColors.appWhiteColor),
                ),
                const Spacer(),
                FaIcon(
                  FontAwesomeIcons.shieldAlt,
                  color: isVerifyCompleted == true ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  EPColors.appMainColor,
                  EPColors.appMainLightColor,
                  EPColors.appBlackColor,
                ],
              ),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(4, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 15)
              ]),
        ),
      ),
    );
  }
}
