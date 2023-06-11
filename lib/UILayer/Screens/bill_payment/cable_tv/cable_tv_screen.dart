import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/cable_tv_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/cable_tv_controller.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/airtime_screen/airtime_transaction_preview.dart';
import 'package:enk_pay_project/UILayer/helper/verify_pin.dart';
import 'package:enk_pay_project/UILayer/utils/cable_tv_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/string_values.dart';
import '../../../../DataLayer/model/bank_list_response.dart';
import '../../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../../CustomWidget/ReUseableWidget/selector_widget/cable_tv_selector.dart';
import '../../../utils/money_formatter.dart';

class CableTVScreen extends StatefulWidget {
  const CableTVScreen({Key? key}) : super(key: key);

  @override
  State<CableTVScreen> createState() => _CableTVScreenState();
}

class _CableTVScreenState extends State<CableTVScreen> with OnCableTV {
  CableTVController? controller;

  String amount = '';
  @override
  void dispose() {
    controller!.pageState = PageState.loaded;
    super.dispose();
  }

  @override
  void initState() {
    // controller!.dispose();
    super.initState();
  }

  UserWallet? _userWallet;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<CableTVController>(context);
    controller!.setView = this;
    return EPScaffold(
        appBar: EPAppBar(
            title: const Text(
          "Cable Tv",
        )),
        builder: (_) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select cable tv",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: EPColors.appBlackColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CableTVSelector(
                    onSelect: (value) {
                      print(value);
                      controller!.setCableTVSelector = value;
                    },
                  ),
                  EPDropdownButton<UserWallet>(
                      itemsListTitle: "Select Account",
                      iconSize: 22,
                      value: controller?.selectedUserWallet,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.title!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        controller?.selectWallet = v;
                        setState(() {});
                      },
                      items: (controller?.getAccount() ?? [])
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
                  const SizedBox(
                    height: 10,
                  ),
                  EPDropdownButton<String>(
                      itemsListTitle: "Select type",
                      iconSize: 22,
                      value: controller?.getProductType,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.toLowerCase().contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        controller?.setProductType = v;
                        setState(() {});
                      },
                      items: ["prepaid", "postpaid"]
                          .map(
                            (e) => DropdownMenuItem(
                                value: e,
                                child: Row(
                                  children: [
                                    Text(e.toString().toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: EPColors.appBlackColor)),
                                    const Spacer(),
                                  ],
                                )),
                          )
                          .toList()),
                  controller!.getCableEnum != null
                      ? Row(
                          children: [
                            Expanded(
                                child: EPForm(
                              hintText: "Enter Your Decoder Number to Verify",
                              enabledBorderColor: EPColors.appGreyColor,
                              keyboardType: TextInputType.number,
                              onChange: (v) {
                                controller!.setDecoderNumber(v);
                              },
                            )),
                            EPButton(
                              loading:
                                  controller!.pageState == PageState.loading
                                      ? true
                                      : false,
                              title: "Verify",
                              onTap: () {
                                controller!.searchLook();
                              },
                            ),
                          ],
                        )
                      : Container(),
                  isNotEmpty(controller!.customerName)
                      ? ContainButton(
                          bgColor: EPColors.appMainColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            child: Row(
                              children: [
                                Text(
                                  (controller!.customerName ?? ""),
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
                  EPDropdownButton<BasePackage>(
                      itemsListTitle: "Select cable package",
                      iconSize: 22,
                      value: controller?.basePackage,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.dataDesc!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        controller?.selectPackage = v;
                        setState(() {});
                      },
                      items: (controller?.getSelectedProduct() ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                                value: e,
                                child: Row(
                                  children: [
                                    Text(e.dataDesc.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: EPColors.appBlackColor)),
                                    const Spacer(),
                                    Text(
                                        amountFormatterWithoutDecimal(
                                            e.getAmount.toString()),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.2,
                            ),
                            EPButton(
                              title: "Continue",
                              onTap: () {
                                onPreview();
                              },
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ));
  }

  void selectContact() async {
    // showPhoneList(context, contacts, (v) {
    //   phoneNumberController.text = v.phones.first.number;
    // });
  }

  void selectDataType() async {
    List<BasePackage>? basePackage;
    if (controller!.getCableEnum != null) {
      switch (controller!.getCableEnum) {
        case CableEnum.dsTv:
          basePackage = controller!.getDSTVProduct();
          break;
        case CableEnum.goTv:
          basePackage = controller!.getGoTVProduct();
          break;
        // case CableEnum.startTimes:
        //   basePackage = controller.getStarTimesProduct();
        //   break;
        default:
          break;
      }
    }
  }

  @override
  onBuyData() {
    controller!.payment();
  }

  @override
  onError(String message) {
    snackBar(context, message: message);
  }

  @override
  onPInVerify() {
    verifyPin(context, onSuccess: () {
      onBuyData();
    });
  }

  @override
  onPreview() async {
    bool? isPop = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AirtimeTransactionPreview()));
    if (isPop != null) {
      onPInVerify();
    }
  }

  @override
  onSuccess(String message) {
    snackBar(context, message: message);
  }
}
