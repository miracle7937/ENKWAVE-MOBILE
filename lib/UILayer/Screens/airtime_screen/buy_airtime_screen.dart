import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/buy_airtime_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:provider/provider.dart';

import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class BuyAirtimeScreen extends StatefulWidget {
  const BuyAirtimeScreen({Key? key}) : super(key: key);

  @override
  _BuyAirtimeScreenState createState() => _BuyAirtimeScreenState();
}

class _BuyAirtimeScreenState extends State<BuyAirtimeScreen> with AirtimeView {
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  late List<Contact>? contacts;

  @override
  void dispose() {
    _airtimeController.clearData();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  getPhoneNumber() async {
    // Get all contacts (lightly fetched)
    contacts = await _contactPicker.selectContacts();
  }

  late AirtimeController _airtimeController;
  @override
  Widget build(BuildContext context) {
    _airtimeController = Provider.of<AirtimeController>(context)..setView(this);
    return EPScaffold(
        // state: AppState(pageState: _airtimeController.pageState),
        appBar: EPAppBar(
          title: const Text(
            "Airtime",
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
                    "Select Network Provider",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: EPColors.appBlackColor),
                  ),
                  SizedBox(
                    child: AirtimeSelector(
                      onSelect: (NetworkSelector value) {
                        _airtimeController.setAirtimeType = value;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EPForm(
                          controller: phoneNumberController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          hintText: "Enter  phone number",
                          enabledBorderColor: EPColors.appGreyColor,
                          keyboardType: TextInputType.phone,
                          onChange: (v) {
                            _airtimeController.setPhone = v;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  EPForm(
                    controller: amountController,
                    hintText: "Enter amount",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.number,
                    onChange: (v) {
                      _airtimeController.setAmount = v;
                    },
                  ),
                  SizedBox(
                    child: AmountSelection(
                      onChange: (v) {
                        _airtimeController.setAmount = v;
                        amountController.text = v;
                      },
                    ),
                    height: 60,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  EPButton(
                    loading: PageState.loading == _airtimeController.pageState,
                    title: "Continue",
                    onTap: () {
                      _airtimeController.onSummit();
                    },
                  ),
                ],
              ),
            ));
  }

  void selectContact() async {
    if (contacts == null) {
      return;
    }
    showPhoneList(context, contacts!, (v) {
      phoneNumberController.text = v.phoneNumbers?.first ?? "";
    });
  }

  @override
  void onError(String message) {
    if (mounted) {
      showEPStatusDialog(context, success: false, message: message,
          callback: () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void onPInVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        _airtimeController.setPin = pin;
        onBuyAirtime();
      } else {
        onError(message);
      }
    });
  }

  @override
  void onBuyAirtime() {
    _airtimeController.buyAirtel();
  }
}

class AmountSelection extends StatelessWidget {
  final Function(String)? onChange;
  const AmountSelection({Key? key, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [100, 200, 500, 1000]
            .map((e) => InkWell(
                  onTap: () {
                    onChange!(e.toString());
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: EPColors.appMainColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "NGN $e",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          color: EPColors.appMainColor,
                                          fontWeight: FontWeight.w500),
                                ),
                              )))),
                ))
            .toList(),
      ),
    );
  }
}
