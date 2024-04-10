import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/controllers/transfer_controller.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/money_formatter.dart';
import '../../utils/status_screen.dart';

class TransferToOtherBank extends StatefulWidget {
  const TransferToOtherBank({Key? key}) : super(key: key);

  @override
  _TransferToOtherBankState createState() => _TransferToOtherBankState();
}

class _TransferToOtherBankState extends State<TransferToOtherBank>
    with OnBankTransfer {
  TextEditingController selectedBankController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TransferController? transferController;
  UserWallet? selectedUserWallet;
  bool saveBeneficiary = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransferController>(context, listen: false).getLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    transferController?.disposeAll();
  }

  @override
  Widget build(BuildContext context) {
    transferController = Provider.of<TransferController>(context)
      ..onSetTransferView = this
      ..getListOFBank();
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "Bank Transfer",
        ),
      ),
      builder: (_) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Transfer money from your account to a separate bank account",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w400, color: EPColors.appBlackColor),
            ),
            const SizedBox(
              height: 10,
            ),
            EPDropdownButton<UserWallet>(
                itemsListTitle: "Select Account",
                iconSize: 22,
                value: transferController?.selectedUserWallet,
                hint: const Text(""),
                isExpanded: true,
                underline: const Divider(),
                searchMatcher: (item, text) {
                  return item.title!.toLowerCase().contains(text.toLowerCase());
                },
                onChanged: (v) {
                  transferController?.selectWallet = v;
                  setState(() {});
                },
                items: transferController?.userWallet
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () => setBeneficiary(
                        (transferController?.getBeneficary ?? [])),
                    child: Row(
                      children: [
                        Image.asset(EPImages.beneficiary),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Send to Beneficiary",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: EPColors.appBlackColor))
                      ],
                    ),
                  )
                ],
              ),
            ),
            EPDropdownButton<Bank>(
                itemsListTitle: "Select Bank",
                iconSize: 22,
                value: transferController?.selectedBank,
                hint: const Text(""),
                isExpanded: true,
                underline: const Divider(),
                searchMatcher: (item, text) {
                  return item.bankName!
                      .toLowerCase()
                      .contains(text.toLowerCase());
                },
                onChanged: (v) {
                  transferController?.setBank = v;
                  setState(() {});
                },
                items: (transferController?.listOfBank ?? [])
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.bankName.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: EPColors.appBlackColor)),
                      ),
                    )
                    .toList()),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: EPForm(
                    controller: accountController,
                    hintText: "Account number",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChange: (v) {
                      transferController?.selectAccount = v;
                      if (v.length >= 10) {
                        transferController?.bankAccountVerification();
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: EPButton(
                    title: "Verify",
                    onTap: () {
                      transferController?.bankAccountVerification();
                    },
                  ),
                )
              ],
            ),
            isNotEmpty(transferController?.accountName)
                ? ContainButton(
                    bgColor: EPColors.appMainColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            (transferController?.accountName ?? ""),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(),
            Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Add as beneficiary",
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: EPColors.appBlackColor)),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
                      activeColor: EPColors.appMainColor,
                      value:
                          (transferController?.bankTransferModel.beneficiary ??
                              false),
                      onChanged: (v) => transferController?.setBeneficiary = v,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                EPForm(
                  hintText: "Enter Amount",
                  enabledBorderColor: EPColors.appGreyColor,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChange: (v) {
                    transferController?.selectAmount = v;
                  },
                ),
                Text(
                    "Charges: ${amountFormatter(transferController?.getTransferCharge().toString())}",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: EPColors.appBlackColor)),
              ],
            ),
            EPForm(
              hintText: "Narration",
              enabledBorderColor: EPColors.appGreyColor,
              onChange: (v) {
                transferController?.setNarration = v;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            isNotEmpty(transferController?.getTotal())
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
                        child: Text(
                            "${amountFormatter(transferController?.getTotal())}",
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
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            EPButton(
              loading: transferController?.pageState == PageState.loading,
              title: "Continue",
              onTap: () {
                FocusNode().unfocus();
                transferController?.validateTransferForm();
              },
            ),
          ],
        ),
      ),
    );
  }

  setBeneficiary(List<Beneficariy> recipients) {
    showBeneficiaryList(context, recipients, (Beneficariy beneficariy) {
      TransferController transferController =
          Provider.of<TransferController>(context, listen: false);
      transferController.bankTransferModel.bankCode = beneficariy.bankCode;
      transferController.bankTransferModel.accountNumber = beneficariy.acctNo;
      transferController.setBank = transferController.listOfBank
          .firstWhere((element) => element.bankCbnCode == beneficariy.bankCode);
      accountController.text = beneficariy.acctNo.toString();
      transferController.bankAccountVerification();
    });
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String message) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => StatusScreen(
                  title: message,
                  onTap: () {},
                )));
  }

  @override
  onTransferPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        transferController?.setPin = pin;
        onTransfer();
      } else {
        onError(message);
      }
    });
  }

  @override
  onTransferSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  onTransfer() {
    transferController?.bankTransfer();
  }

  @override
  onPreview(String message) {}
}
