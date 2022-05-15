import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/internal_transfer_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/in_app_transfer_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/helper/verify_pin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

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
      ..setView = this;

    return EPScaffold(
      appBar: EPAppBar(
        title: Text(
          "EnkPay Transfer",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.w600, color: EPColors.appBlackColor),
        ),
      ),
      builder: (_) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: EPForm(
                  controller: phoneNumberController,
                  hintText: "Enter  phone number",
                  enabledBorderColor: EPColors.appGreyColor,
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
                  child: Image.asset(EPImages.contactIcon),
                ),
              )
            ],
          ),
          EPForm(
            enable: false,
            hintText: transferController!.searchName,
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
            onChange: (v) {},
          ),
          EPForm(
            controller: amountController,
            hintText: "Enter amount",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
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
            title: "Continue",
            onTap: () {
              onPreview();
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
      transferController!.phoneNumber = v.phones.first.number;
    });
  }

  @override
  onError(String message) {
    print('error----------');
    snackBar(context, message: message);
  }

  @override
  onPinVerification() {
    verifyPin(context, onSuccess: () {
      transferController!.transfer();
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
    snackBar(context, message: message);
  }
}
