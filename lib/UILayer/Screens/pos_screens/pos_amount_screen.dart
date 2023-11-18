import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_amount_pad.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

class PosAmountScreen extends StatefulWidget {
  const PosAmountScreen({Key? key, required this.onAmount}) : super(key: key);
  final Function(String? value) onAmount;

  @override
  State<PosAmountScreen> createState() => _PosAmountScreenState();
}

class _PosAmountScreenState extends State<PosAmountScreen> {
  String? amount;
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
                codeVerify: (v) {
                  amount = v;
                  return Future.value(true);
                }),
            EPButton(
              onTap: () {
                widget.onAmount(amount);
              },
              title: 'Charge',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
