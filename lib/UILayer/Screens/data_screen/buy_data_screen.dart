import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/on_mobile_data_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/mobile_data_controller.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_multi_formatter/formatters/formatter_extension_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/model/bank_list_response.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class BuyDataScreen extends StatefulWidget {
  const BuyDataScreen({Key? key}) : super(key: key);

  @override
  _BuyDataScreenState createState() => _BuyDataScreenState();
}

class _BuyDataScreenState extends State<BuyDataScreen> with OnMobileDataView {
  late List<Contact> contacts;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController selectedBankController = TextEditingController();

  @override
  void dispose() {
    mobileDataController.clearData();
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

  late MobileDataController mobileDataController;
  String amount = '';
  UserWallet? userWallet;
  @override
  Widget build(BuildContext context) {
    mobileDataController = Provider.of<MobileDataController>(context)
      ..setView = this
      ..initialize();
    return EPScaffold(
      // state: AppState(pageState: mobileDataController.pageState),
      appBar: EPAppBar(
        title: const Text(
          "Data Bundle",
        ),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Select Network Provider",
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w400, color: EPColors.appBlackColor),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: AirtimeSelector(
                  onSelect: (NetworkSelector value) {
                    mobileDataController.setNetworkSelector = value;
                    mobileDataController.basePackage = null;
                    descriptionController.text = '';
                    amount = '';
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              EPForm(
                controller: selectedBankController,
                callback: () {
                  showWalletList(context, mobileDataController.getAccount(),
                      (UserWallet wallet) {
                    mobileDataController.pickWallet(wallet);
                    selectedBankController.text = wallet.title!;
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
                hintText: "Select Account",
                enabledBorderColor: EPColors.appGreyColor,
                keyboardType: TextInputType.phone,
                onChange: (v) {
                  mobileDataController.pickWallet(v);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: EPForm(
                      controller: phoneNumberController,
                      hintText: "Enter  phone number",
                      enabledBorderColor: EPColors.appGreyColor,
                      keyboardType: TextInputType.phone,
                      onChange: (v) {
                        mobileDataController.setPhoneNumber = v;
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
              Row(children: [
                TextClickButton(
                  title: "Select your phone number",
                  textStyle: Theme.of(context).textTheme.headline3!.copyWith(
                      color: EPColors.appMainColor,
                      fontWeight: FontWeight.w500),
                  onTap: () async {
                    String? phoneNumber = await LocalDataStorage.getPhone();
                    phoneNumberController.text = phoneNumber!;
                    mobileDataController.setPhoneNumber = phoneNumber;
                  },
                ),
              ]),
              const SizedBox(
                height: 15,
              ),
              EPForm(
                controller: descriptionController,
                callback: () {
                  selectDataType();
                },
                enable: false,
                hintText: "Select Package",
                enabledBorderColor: EPColors.appGreyColor,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              isNotEmpty(amount)
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
                              "NGN ${double.parse(amount).toCurrencyString(mantissaLength: 0).toString()}",
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
                height: MediaQuery.of(context).size.width * 0.2,
              ),
              EPButton(
                loading: mobileDataController.pageState == PageState.loading,
                title: "Continue",
                onTap: () {
                  mobileDataController.validateDataForm();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void selectDataType() async {
    List<BasePackage>? basePackage;
    if (mobileDataController.getNetworkSelector != null) {
      switch (mobileDataController.getNetworkSelector) {
        case NetworkSelector.mtn:
          basePackage = mobileDataController.getMTNDataProduct();
          break;
        case NetworkSelector.glo:
          basePackage = mobileDataController.getGloDataProduct();
          break;
        case NetworkSelector.airtel:
          basePackage = mobileDataController.getAirtelDataProduct();
          break;
        case NetworkSelector.n9Mobile:
          basePackage = mobileDataController.get9mobileDataProduct();
          break;
        default:
          break;
      }

      showListOFDataPackage(context, basePackage, (v) {
        setState(() {
          amount = v.getAmount!;
          descriptionController.text = v.getDesc!;
          mobileDataController.setPackage = v;
        });
      });
    }
  }

  void selectContact() async {
    showPhoneList(context, contacts, (v) {
      phoneNumberController.text = v.phones.first.number;
      mobileDataController.setPhoneNumber = v.phones.first.number;
    });
  }

  @override
  onPInVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        mobileDataController.setPin = pin;
        onBuyData();
      } else {
        onError(message);
      }
    });
  }

  @override
  onBuyData() {
    mobileDataController.onBuyMobileData();
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
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
