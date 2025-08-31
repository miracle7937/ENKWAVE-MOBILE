import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Constant/colors.dart';
import '../CustomWidget/ReUseableWidget/ep_button.dart';
import '../CustomWidget/ReUseableWidget/snack_bar.dart';
import 'money_formatter.dart';

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

Future<void> alertIncomeTransfer(
  BuildContext context, {
  required String? name,
  required String? bank,
  required String? amount,
  VoidCallback? onReprint,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.compare_arrows_rounded,
              size: 50, color: Colors.green),
          const SizedBox(height: 16),
          Text(
            'Incoming Transfer Alert'.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(context, "Sender Name", name),
          const SizedBox(height: 12),
          _buildDetailItem(context, "Sender Bank", bank?.toUpperCase()),
          const SizedBox(height: 18),
          Text(
            "Amount",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            amountFormatterWithoutDecimal(amount),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: EPColors.appMainColor,
                ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.redAccent,
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            if (onReprint != null) onReprint();
          },
          icon: const Icon(
            Icons.print,
            color: Colors.white,
          ),
          label: const Text(
            "Reprint",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: EPColors.appMainColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDetailItem(BuildContext context, String title, String? value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: Text(
          "$title:",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 10),
        ),
      ),
      Expanded(
        flex: 6,
        child: Text(
          value ?? "-",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    ],
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
                  Clipboard.setData(ClipboardData(text: accountNumber ?? ""))
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
