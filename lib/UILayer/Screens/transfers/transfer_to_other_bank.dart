import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/transfer_controller.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferToOtherBank extends StatefulWidget {
  const TransferToOtherBank({Key? key}) : super(key: key);

  @override
  _TransferToOtherBankState createState() => _TransferToOtherBankState();
}

class _TransferToOtherBankState extends State<TransferToOtherBank>
    with OnBankTransfer {
  TextEditingController selectedBankController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TransferController transferController =
        Provider.of<TransferController>(context)
          ..onSetTransferView = this
          ..getListOFBank();
    return EPScaffold(
      appBar: EPAppBar(
        title: Text(
          "Bank Transfer",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.w600, color: EPColors.appBlackColor),
        ),
      ),
      builder: (_) => Column(
        children: [
          EPForm(
            controller: selectedBankController,
            callback: () {
              showBankList(context, transferController.listOfBank, (Bank bank) {
                transferController.selectBank = bank;
                selectedBankController.text = bank.bankName!;
              });
            },
            suffixWidget: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 30,
                )
              ],
            ),
            enable: false,
            hintText: "Select Bank",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.phone,
            onChange: (v) {
              transferController.selectAccount = v;
            },
          ),
          EPForm(
            hintText: "Account number",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
            onChange: (v) {},
          ),
          EPForm(
            hintText: "Adejimi Tolulope Adewale",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
            onChange: (v) {},
          ),
          EPForm(
            hintText: "Enter Amount",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
            onChange: (v) {
              transferController.selectAmount = v;
            },
          ),
          const Spacer(
            flex: 2,
          ),
          EPButton(
            title: "Continue",
            onTap: () {},
          ),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }

  @override
  onError(String message) {}

  @override
  onSuccess(String message) {}
}
