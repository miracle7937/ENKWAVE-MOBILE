import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/internal_transfer_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/in_app_transfer_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:enk_pay_project/UILayer/utils/format_phone_number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../Constant/string_values.dart';
import '../../../DataLayer/model/bank_list_response.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/money_formatter.dart';
import 'inapp_preview_screen.dart';

class TransferInApp extends StatefulWidget {
  const TransferInApp({Key? key}) : super(key: key);

  @override
  _TransferInAppState createState() => _TransferInAppState();
}

class _TransferInAppState extends State<TransferInApp>
    with InternalTransferView {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late List<Contact> contacts;

  getPhoneNumber() async {
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
    }
  }

  @override
  void initState() {
    getPhoneNumber();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    transferController!.clearAPP();
  }

  InAppTransferController? transferController;
  @override
  Widget build(BuildContext context) {
    transferController = Provider.of<InAppTransferController>(context)
      ..setView = this
      ..getWallet();

    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "EnkPay Transfer",
        ),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Transfer money from your account to an EnkPay user",
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
              items: (transferController?.userWallets ?? [])
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: EPForm(
                  controller: phoneNumberController,
                  hintText: "Enter  phone number",
                  enabledBorderColor: EPColors.appGreyColor,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  onChange: (v) {
                    transferController!.phoneNumber = v;
                    transferController!.verifyUserNumber(v);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    selectContact();
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.addressBook,
                  ),
                  // child: Image.asset(EPImages.contactIcon),
                ),
              )
            ],
          ),
          isNotEmpty(transferController!.searchName)
              ? ContainButton(
                  bgColor: EPColors.appMainColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          (transferController!.searchName ?? ""),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(),
          EPForm(
            controller: amountController,
            hintText: "Enter amount",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChange: (v) {
              transferController!.setAmount = v;
            },
          ),
          EPForm(
            hintText: "Description",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.text,
            onChange: (v) {
              transferController!.setDesc = v;
            },
          ),
          const Spacer(
            flex: 2,
          ),
          EPButton(
            loading: transferController?.pageState == PageState.loading,
            title: "Continue",
            onTap: () {
              transferController?.validateTransferForm();
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void selectContact() async {
    showPhoneList(context, contacts, (v) {
      phoneNumberController.text = v.phones.first.number;
      transferController!.phoneNumber =
          PhoneNumber.format(v.phones.first.number);
    });
  }

  @override
  onError(String message) {
    if (mounted) {
      showEPStatusDialog(context, success: false, message: message,
          callback: () {
        Navigator.pop(context);
      });
    }
  }

  @override
  onPinVerification() {
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
  onPreview() async {
    bool? isPop = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const InAppPreviewScreen()));
    if (isPop != null) {
      onPinVerification();
    }
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  onTransfer() {
    transferController!.transfer();
  }

  @override
  onFailNumberVerify(String message) {
    snackBar(context, message: message);
  }
}
