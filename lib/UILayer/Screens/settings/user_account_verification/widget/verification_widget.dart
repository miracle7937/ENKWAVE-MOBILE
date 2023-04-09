import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../Constant/colors.dart';

class AccountVerificationWidget extends StatelessWidget {
  final bool? isVerifyCompleted;
  final String title;
  final VoidCallback? onTap;

  const AccountVerificationWidget(
      {Key? key,
      this.isVerifyCompleted = false,
      this.onTap,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: InkWell(
        onTap: isVerifyCompleted == true ? null : onTap,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: EPColors.appBlackColor),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FaIcon(
                  isVerifyCompleted == true
                      ? FontAwesomeIcons.check
                      : FontAwesomeIcons.times,
                  color: isVerifyCompleted == true ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
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
