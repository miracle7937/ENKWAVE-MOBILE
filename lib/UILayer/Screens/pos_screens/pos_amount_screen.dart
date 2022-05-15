import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_amount_pad.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

class PosAmountScreen extends StatelessWidget {
  const PosAmountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            AmountScreen(
                codeLength: 6,
                codeVerify: (code) {
                  print(code);

                  return Future.value(true);
                }),
            EPButton(
              onTap: () {},
              title: 'Charge',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
