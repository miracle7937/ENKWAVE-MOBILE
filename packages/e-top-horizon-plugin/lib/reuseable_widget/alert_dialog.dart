import 'package:flutter/material.dart';

import 'cards.dart';

Future showPurchaseSelectableDialog(
  BuildContext context, {
  VoidCallback? onReversal,
  VoidCallback? onRefund,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Wrap(
        children: [
          Column(
            children: [
              CardWidgetWithBG(
                title: "Reversal",
                callback: () {
                  Navigator.pop(context);
                  onReversal!();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CardWidgetWithBG(
                title: "Refund",
                callback: () {
                  Navigator.pop(context);
                  onRefund!();
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
