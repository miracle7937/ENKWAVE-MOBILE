import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/cable_tv_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CableTVScreen extends StatelessWidget {
  const CableTVScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
        appBar: EPAppBar(
            title: Text("Cable Tv",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: EPColors.appBlackColor))),
        builder: (_) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select cable tv",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: EPColors.appBlackColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CableTVSelector(
                    onSelect: (v) {
                      print(v);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  EPForm(
                    hintText: "Enter amount",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.number,
                    onChange: (v) {},
                  ),
                  EPForm(
                    callback: () {},
                    enable: false,
                    hintText: "Select Package",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Center(
                    child: Text("Amount",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: EPColors.appGreyColor)),
                  ),
                  Center(
                    child: Text("NGN 3,500",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 40,
                            color: EPColors.appBlackColor)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                  EPButton(
                    title: "Continue",
                    onTap: () {},
                  ),
                ],
              ),
            ));
  }

  void selectContact() async {
    // showPhoneList(context, contacts, (v) {
    //   phoneNumberController.text = v.phones.first.number;
    // });
  }
}
