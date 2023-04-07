import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/buy_airtime_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/model/bank_list_response.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/format_phone_number.dart';
import '../../utils/money_formatter.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class BuyAirtimeScreen extends StatefulWidget {
  const BuyAirtimeScreen({Key? key}) : super(key: key);

  @override
  _BuyAirtimeScreenState createState() => _BuyAirtimeScreenState();
}

class _BuyAirtimeScreenState extends State<BuyAirtimeScreen> with AirtimeView {
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late List<Contact> contacts;

  @override
  void dispose() {
    _airtimeController.clearData();
    super.dispose();
  }

  @override
  void initState() {
    getPhoneNumber();
    super.initState();
  }

  getPhoneNumber() async {
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
    }
  }

  late AirtimeController _airtimeController;
  @override
  Widget build(BuildContext context) {
    _airtimeController = Provider.of<AirtimeController>(context)
      ..setView(this)
      ..getWallet();
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
                  EPDropdownButton<UserWallet>(
                      itemsListTitle: "Select Account",
                      iconSize: 22,
                      value: _airtimeController.selectedUserWallet,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.title!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        _airtimeController.selectWallet = v;
                        setState(() {});
                      },
                      items: (_airtimeController.userWallet ?? [])
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
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          selectContact();
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.addressBook,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      TextClickButton(
                        title: "Select mobile number",
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                                color: EPColors.appMainColor,
                                fontWeight: FontWeight.w500),
                        onTap: () async {
                          String? phoneNumber =
                              await LocalDataStorage.getPhone();
                          phoneNumberController.text = phoneNumber!;
                          _airtimeController.setPhone = phoneNumber;
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const FaIcon(
                        Icons.person,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
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
    showPhoneList(context, contacts, (v) {
      phoneNumberController.text = PhoneNumber.format(v.phones.first.number);
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
