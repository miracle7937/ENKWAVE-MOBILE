import 'package:flutter/material.dart';

import '../constant/color.dart';
import '../utils/null_checker.dart';
import 'buttons.dart';

formAlertDialog(
  BuildContext context,
  String title,
  Function(String amount) onChange,
) {
  String? amount;
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titleTextStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
      title: Text(title),
      content: Wrap(
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              onChanged: (v) {
                amount = v;
              },
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: EPColors.appMainColor),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Amount",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
              ),
            ),
          )
        ],
      ),
      actions: [
        EPButton(
          title: "Continue",
          onTap: () {
            if (isNotEmpty(amount)) {
              Navigator.pop(context);
              onChange(amount!);
            }
          },
        ),
      ],
    ),
  );
}
