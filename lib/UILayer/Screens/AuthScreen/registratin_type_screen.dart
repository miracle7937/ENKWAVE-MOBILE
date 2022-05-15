import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationTypeScreen extends StatelessWidget {
  const RegistrationTypeScreen({Key? key}) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return EPScaffold(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Account Type",
                maxLines: 2,
                style: Theme.of(context).textTheme.headline2!.copyWith(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Select the type of account you will like to create",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          _selectRegistrationTYpe(context, "Personal", () {}),
          _selectRegistrationTYpe(context, "Business", () {})
        ],
      );
    });
  }

  _selectRegistrationTYpe(
      BuildContext context, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onTap,
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18),
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: EPColors.appGreyColor, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
