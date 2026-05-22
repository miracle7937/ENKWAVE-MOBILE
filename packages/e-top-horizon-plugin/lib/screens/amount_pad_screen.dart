import 'package:flutter/material.dart';

import '../reuseable_widget/amount_screen.dart';
import '../reuseable_widget/buttons.dart';
import '../reuseable_widget/custom_snack_bar.dart';
import '../utils/transaction_type.dart';

class PosAmountScreen extends StatefulWidget {
  final TransactionType transactionType;
  final String? title;
  final Function(String)? onSelectAmount;
  const PosAmountScreen(
      {Key? key,
      required this.transactionType,
      this.onSelectAmount,
      this.title})
      : super(key: key);

  @override
  State<PosAmountScreen> createState() => _PosAmountScreenState();
}

class _PosAmountScreenState extends State<PosAmountScreen> {
  String amount = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AmountScreen(
                  title: widget.title,
                  codeLength: 6,
                  codeVerify: (v) {
                    setState(() {
                      amount = v;
                    });
                    return Future.value(true);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: EPButton(
                onTap: () {
                  final parsed = num.tryParse(amount);
                  if (parsed == null || parsed < 0) {
                    customSnackBar(context,
                        message: "please check your amount.....");
                  } else {
                    Navigator.pop(context);
                    widget.onSelectAmount!(amount);
                  }
                },
                title: 'Charge',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
