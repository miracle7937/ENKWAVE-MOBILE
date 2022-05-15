import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/on_mobile_data_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/mobile_data_controller.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/helper/verify_pin.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_multi_formatter/formatters/formatter_extension_methods.dart';
import 'package:provider/provider.dart';

import 'mobile_data_preview.dart';

class BuyDataScreen extends StatefulWidget {
  const BuyDataScreen({Key? key}) : super(key: key);

  @override
  _BuyDataScreenState createState() => _BuyDataScreenState();
}

class _BuyDataScreenState extends State<BuyDataScreen> with OnMobileDataView {
  late List<Contact> contacts;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
  @override
  Widget build(BuildContext context) {
    mobileDataController = Provider.of<MobileDataController>(context)
      ..setView = this;
    return EPScaffold(
      state: AppState(pageState: mobileDataController.pageState),
      appBar: EPAppBar(
        title: Text(
          "Data Bundle",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.w600, color: EPColors.appBlackColor),
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
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: EPColors.appBlackColor),
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
                height: MediaQuery.of(context).size.height * 0.2,
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
                    child: Image.asset(EPImages.contactIcon),
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
                title: "Continue",
                onTap: () {
                  mobileDataController.summitButton();
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
          mobileDataController.basePackage = v;
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
  onPreview() async {
    bool? isPop = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MobileDataPreview()));
    if (isPop != null) {
      onPInVerify();
    }
  }

  @override
  onPInVerify() {
    verifyPin(context, onSuccess: () {
      onBuyData();
    });
  }

  @override
  onBuyData() {
    mobileDataController.onBuyMobileData();
  }

  @override
  onError(String message) {
    snackBar(context, message: message);
  }

  @override
  onSuccess(String message) {
    snackBar(context, message: message);
  }
}
