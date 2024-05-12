import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../Constant/string_values.dart';
import '../../../DataLayer/abstract_class/on_mobile_data_view.dart';
import '../../../DataLayer/controllers/mobile_data_controller.dart';
import '../../../DataLayer/model/data_model_response.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../../utils/airtime_enum.dart';
import '../../utils/linear_progress_bar.dart';
import '../../utils/money_formatter.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class BuyDataScreenNew extends StatefulWidget {
  const BuyDataScreenNew({Key? key}) : super(key: key);

  @override
  State<BuyDataScreenNew> createState() => _BuyDataScreenNewState();
}

class _BuyDataScreenNewState extends State<BuyDataScreenNew>
    with OnMobileDataView {
  TextEditingController phoneNumberController = TextEditingController();
  late MobileDataController mobileDataController;

  @override
  void dispose() {
    super.dispose();
    mobileDataController.clearData();
  }

  @override
  Widget build(BuildContext context) {
    mobileDataController = Provider.of<MobileDataController>(context)
      ..setView = this;
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "Data Bundle",
        ),
      ),
      builder: (_) => SingleChildScrollView(
        child: Column(
          children: [
            EPLinearProgressBar(
              loading: mobileDataController.pageState == PageState.loading,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Select Network Provider",
              style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontWeight: FontWeight.w500, color: EPColors.appBlackColor),
            ),
            SizedBox(
              child: AirtimeSelector(
                onSelect: (NetworkSelector value) {
                  mobileDataController.setNetworkType = value;
                },
              ),
            ),
            EPForm(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              controller: phoneNumberController,
              hintText: "Enter  phone number",
              enabledBorderColor: EPColors.appGreyColor,
              keyboardType: TextInputType.phone,
              onChange: (v) {
                if (v.length > 10) {
                  mobileDataController.setPhoneNumber = v;
                }
              },
            ),
            mobileDataController.listOfPlan != null
                ? EPDropdownButton<AirtimeDataPlan>(
                    itemsListTitle: "Please select plan",
                    iconSize: 22,
                    value: mobileDataController.selectedPlan,
                    hint: const Text(""),
                    isExpanded: true,
                    underline: const Divider(),
                    searchMatcher: (item, text) {
                      return item.dataBundle!
                          .toLowerCase()
                          .contains(text.toLowerCase());
                    },
                    onChanged: (v) {
                      mobileDataController.setPackage = v;
                      setState(() {});
                    },
                    items: (mobileDataController.listOfPlan ?? [])
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                Text("${e.dataBundle}(${e.validity})",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: EPColors.appBlackColor)),
                                const Spacer(),
                                Text(amountFormatterWithoutDecimal(e.amount),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: EPColors.appBlackColor)),
                              ],
                            ),
                          ),
                        )
                        .toList())
                : Container(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Column(
              children: [
                isNotEmpty(mobileDataController.selectedPlan?.amount)
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
                                amountFormatterWithoutDecimal(
                                    mobileDataController.selectedPlan?.amount),
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
                EPButton(
                  loading: mobileDataController.pageState == PageState.loading,
                  title: "Pay",
                  onTap: () {
                    // print(mobileDataController.buyDataModel.toJson());
                    mobileDataController.validateDataForm();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  onBuyData() {
    mobileDataController.onBuyMobileAirtime();
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
