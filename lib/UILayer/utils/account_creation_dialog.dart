import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CustomWidget/ReUseableWidget/ep_button.dart';
import '../CustomWidget/ReUseableWidget/snack_bar.dart';

accountCreationDialog(BuildContext context, {VoidCallback? onProceed}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('INFO'),
      content: Text(
        'This user does not have any associated bank accounts. Please go ahead and open a bank account.',
        style: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
      ),
      actions: [
        EPButton(
          title: "Proceed",
          onTap: onProceed,
        ),
      ],
    ),
  );
}

showTransferDialog(BuildContext context,
    {VoidCallback? onProceed, String? accountNumber, accountName, bankName}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: const [
          Spacer(),
          Text('ACCOUNT INFO'),
          Spacer(),
        ],
      ),
      content: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Receive cash in your wallet',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 15),
              Text(
                'Virtual Account Number',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: accountNumber))
                      .then((value) {
                    snackBar(context, message: "$accountNumber copied");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      accountNumber ?? "",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const FaIcon(FontAwesomeIcons.copy),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Account Name',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                accountName ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(
                'Bank Name',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                bankName ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      actions: [
        EPButton(
          title: "OK",
          onTap: onProceed ?? () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
