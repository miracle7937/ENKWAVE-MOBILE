import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../Constant/string_values.dart';
import '../../../DataLayer/controllers/electric_company_controller.dart';
import '../../../DataLayer/model/electricity_model/electric_company_model.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/loader_widget.dart';
import '../../utils/money_formatter.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({Key? key}) : super(key: key);

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen>
    with ElectricView {
  ElectricCompanyController? electricCompanyController;

  @override
  void dispose() {
    super.dispose();
    electricCompanyController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "Electricity Payment",
        ),
      ),
      builder: (_) => FutureBuilder<void>(
          future: Provider.of<ElectricCompanyController>(context, listen: false)
              .fetchElectricCompany(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderWidget();
            }
            return Consumer<ElectricCompanyController>(
                builder: (context, myProvider, child) {
              electricCompanyController = myProvider;
              myProvider.setView(this);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Pay for Electricity",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: EPColors.appBlackColor),
                    ),
                    EPDropdownButton<UserWallet>(
                        itemsListTitle: "Select Account",
                        iconSize: 22,
                        value: myProvider.setWallet,
                        hint: const Text(""),
                        isExpanded: true,
                        underline: const Divider(),
                        searchMatcher: (item, text) {
                          return item.title!
                              .toLowerCase()
                              .contains(text.toLowerCase());
                        },
                        onChanged: (v) {
                          myProvider.selectedWallet = v;
                          setState(() {});
                        },
                        items: (myProvider.userWallet ?? [])
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
                                                  color:
                                                      EPColors.appBlackColor)),
                                      const Spacer(),
                                      Text(amountFormatter(e.amount.toString()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      EPColors.appBlackColor)),
                                    ],
                                  )),
                            )
                            .toList()),
                    const SizedBox(
                      height: 20,
                    ),
                    EPDropdownButton<ElectricCompanyData>(
                        itemsListTitle: "Select Provider",
                        iconSize: 22,
                        value: myProvider.selectedElectricCompany,
                        hint: const Text(""),
                        isExpanded: true,
                        underline: const Divider(),
                        searchMatcher: (item, text) {
                          return item.name!
                              .toLowerCase()
                              .contains(text.toLowerCase());
                        },
                        onChanged: (v) {
                          myProvider.setElectricCompany = v;
                        },
                        items: (myProvider.electricCompany ?? [])
                            .map(
                              (e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Text(e.name.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      EPColors.appBlackColor)),
                                      const Spacer(),
                                    ],
                                  )),
                            )
                            .toList()),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: EPForm(
                            hintText: "Meter number",
                            enabledBorderColor: EPColors.appGreyColor,
                            keyboardType: TextInputType.number,
                            onChange: (v) {
                              myProvider.selectMeterNO = v;
                            },
                          ),
                        ),
                        Expanded(
                          child: EPButton(
                            title: "Verify",
                            onTap: () {
                              myProvider.bankMeterNoVerification();
                            },
                          ),
                        )
                      ],
                    ),
                    isNotEmpty(myProvider.meterAccountName)
                        ? ContainButton(
                            bgColor: EPColors.appMainColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    (myProvider.meterAccountName ?? ""),
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
                    EPDropdownButton<String>(
                        itemsListTitle: "Select type",
                        iconSize: 22,
                        value: myProvider.buyElectricityModel.variationCode,
                        hint: const Text(""),
                        isExpanded: true,
                        underline: const Divider(),
                        searchMatcher: (item, text) {
                          return item
                              .toLowerCase()
                              .contains(text.toLowerCase());
                        },
                        onChanged: (v) {
                          myProvider.setProductType = v;
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
                                                  color:
                                                      EPColors.appBlackColor)),
                                      const Spacer(),
                                    ],
                                  )),
                            )
                            .toList()),
                    EPForm(
                      hintText: "Enter amount",
                      enabledBorderColor: EPColors.appGreyColor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChange: (v) {
                        myProvider.setAmount = v;
                      },
                    ),
                    EPForm(
                      hintText: "Enter  phone number",
                      enabledBorderColor: EPColors.appGreyColor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChange: (v) {
                        myProvider.phoneNumber = v;
                      },
                    ),
                    EPButton(
                      loading: PageState.loading == myProvider.pageState,
                      title: "Continue",
                      onTap: () {
                        myProvider.onStartTransaction();
                      },
                    )
                  ],
                ),
              );
            });
          }),
    );
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        Provider.of<ElectricCompanyController>(context, listen: false).setPin =
            pin;
        onBuyPower();
      } else {
        onError(message);
      }
    });
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  onBuyPower() {
    electricCompanyController?.buyPower();
  }
}
