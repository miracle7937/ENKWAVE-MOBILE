import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_amount_pad.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

class PosAmountScreen extends StatelessWidget {
  const PosAmountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceFill,
      appBar: AppBar(
        title: const Text('POS Payment'),
        backgroundColor: EPColors.appMainColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Enter amount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.primaryText,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Key in the charge amount on the terminal',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: EPColors.appGreyColor,
                          ),
                    ),
                    const SizedBox(height: 12),
                    AmountScreen(
                      codeLength: 6,
                      codeVerify: (code) => Future.value(true),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: EPButton(
                onTap: () {},
                title: 'Charge',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
