import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../Constant/image.dart';
import '../../../DataLayer/controllers/transfer_status_controller.dart';
import 'ep_button.dart';

class TransferStatusPage extends StatelessWidget {
  final VoidCallback? onTap;
  final String? refTransId;
  const TransferStatusPage({Key? key, this.onTap, this.refTransId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferStatusController>(
        builder: (context, myProvider, child) {
      myProvider.getTransaction(refTransId!);
      return EPScaffold(
        state: AppState(
            pageState: myProvider.pageState,
            noDataMessage: myProvider.transactionStatusModel?.message),
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Lottie.asset(
                  EPImages.successJson,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Successful",
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "NGN ${myProvider.transactionStatusModel?.amount ?? ""}",
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Transfer successful. Actual credit time subject to recipient's bank.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Recipient",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    "${myProvider.transactionStatusModel?.receiverName ?? ""} ",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Recipient Bank",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    "${myProvider.transactionStatusModel?.receiverBank ?? ""} ",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w200, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Recipient Account Number",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    "${myProvider.transactionStatusModel?.receiverAccountNo ?? ""} ",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w200, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Reference ID",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    myProvider.transactionStatusModel?.eRef ?? "",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w200, color: Colors.black87),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                              text: myProvider.transactionStatusModel?.eRef ??
                                  ""))
                          .then((value) {
                        snackBar(context, message: "copied");
                      });
                    },
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        FaIcon(FontAwesomeIcons.copy),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              Text(
                myProvider.transactionStatusModel?.message ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontWeight: FontWeight.w300, color: Colors.black87),
              ),
              EPButton(
                title: "OK",
                onTap: onTap,
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
