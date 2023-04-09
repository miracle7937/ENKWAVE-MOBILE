import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../Constant/string_values.dart';
import '../../../DataLayer/controllers/cash_out_controller.dart';
import '../../../DataLayer/model/bank_list_response.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../../utils/linear_progress_bar.dart';
import '../../utils/money_formatter.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class CashOutScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const CashOutScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> with CashOutView {
  CashOutController? _controller;

  @override
  void dispose() {
    super.dispose();
    _controller?.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<CashOutController>(context)
      ..setView(this)
      ..fetchUserWallet();
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text("Self Cashout"),
      ),
      builder: (_) => Column(
        children: [
          EPLinearProgressBar(
            loading: _controller?.isInitialLoading,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Transfer money from your wallet to your default account",
            style: Theme.of(context).textTheme.headline3!.copyWith(
                fontWeight: FontWeight.w400, color: EPColors.appBlackColor),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          EPDropdownButton<UserWallet>(
              itemsListTitle: "Select Account",
              iconSize: 22,
              value: _controller?.userWallet,
              hint: const Text(""),
              isExpanded: true,
              underline: const Divider(),
              searchMatcher: (item, text) {
                return item.title!.toLowerCase().contains(text.toLowerCase());
              },
              onChanged: (v) {
                _controller?.setUserWallet = v;
              },
              items: (_controller?.listOfUserWallets ?? [])
                  .map(
                    (e) => DropdownMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            Text(e.title.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: EPColors.appBlackColor)),
                            const Spacer(),
                            Text(amountFormatter(e.amount.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: EPColors.appBlackColor)),
                          ],
                        )),
                  )
                  .toList()),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              EPForm(
                hintText: "Enter amount",
                enabledBorderColor: EPColors.appGreyColor,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChange: (v) {
                  _controller!.setAmount = v;
                },
              ),
              Text(
                  "Charges: ${amountFormatter(_controller?.getTransferCharge().toString())}",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: EPColors.appBlackColor)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          EPButton(
            loading: PageState.loading == _controller?.pageState,
            title: "Continue",
            onTap: () {
              _controller?.onProcessTransfer();
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          isNotEmpty(_controller?.getTotal())
              ? Column(
                  children: [
                    Center(
                      child: Text("Amount",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: EPColors.appGreyColor)),
                    ),
                    Center(
                      child: Text("${amountFormatter(_controller?.getTotal())}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40,
                                  color: EPColors.appBlackColor)),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
      widget.onRefresh!();
    });
  }

  @override
  onPinVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        _controller?.setPin = pin;
        onCashOut();
      } else {
        onError(message);
      }
    });
  }

  @override
  onCashOut() {
    _controller?.userCashOut();
  }
}
