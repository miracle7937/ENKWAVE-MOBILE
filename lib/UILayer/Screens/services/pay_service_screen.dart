import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../Constant/string_values.dart';
import '../../../DataLayer/abstract_class/internal_transfer_view.dart';
import '../../../DataLayer/controllers/api_service_controller.dart';
import '../../../DataLayer/model/api_property_model.dart';
import '../../../DataLayer/model/bank_list_response.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/money_formatter.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class ApiServiceScreen extends StatefulWidget {
  const ApiServiceScreen({Key? key}) : super(key: key);

  @override
  State<ApiServiceScreen> createState() => _ApiServiceScreenState();
}

class _ApiServiceScreenState extends State<ApiServiceScreen>
    with APIServiceView {
  ApiServiceController? apiServiceController;

  @override
  void dispose() {
    super.dispose();
    apiServiceController?.disposeAll();
  }

  @override
  Widget build(BuildContext context) {
    apiServiceController = Provider.of<ApiServiceController>(context)
      ..setView(this)
      ..getWallet();
    return EPScaffold(
        appBar: EPAppBar(
          title: const Text(
            "Fund Service",
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
                    "Fund money from your account to a service account",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: EPColors.appBlackColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EPDropdownButton<UserWallet>(
                      itemsListTitle: "Select Account",
                      iconSize: 22,
                      value: apiServiceController?.userWallet,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.title!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        apiServiceController?.setUserWallet(v);
                        setState(() {});
                      },
                      items: (apiServiceController
                                  ?.apiServiceProperty?.account ??
                              [])
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
                  EPDropdownButton<Service>(
                      itemsListTitle: "Select Service",
                      iconSize: 22,
                      value: apiServiceController?.selectedService,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.serviceName!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        apiServiceController?.setService(v);
                        setState(() {});
                      },
                      items:
                          (apiServiceController?.apiServiceProperty?.service ??
                                  [])
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.serviceName.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: EPColors.appBlackColor)),
                                ),
                              )
                              .toList()),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: EPForm(
                          hintText: "Enter Your Service Email Address",
                          enabledBorderColor: EPColors.appGreyColor,
                          keyboardType: TextInputType.emailAddress,
                          onChange: (v) {
                            apiServiceController?.setEmail(v);
                          },
                        ),
                      ),
                      Expanded(
                        child: EPButton(
                          title: "Verify",
                          onTap: () {
                            apiServiceController?.serviceLookUP();
                          },
                        ),
                      )
                    ],
                  ),
                  isNotEmpty(apiServiceController?.name)
                      ? ContainButton(
                          bgColor: EPColors.appMainColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            child: Row(
                              children: [
                                Text(
                                  (apiServiceController?.name ?? ""),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      EPForm(
                        hintText: "Enter Amount",
                        enabledBorderColor: EPColors.appGreyColor,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChange: (v) {
                          apiServiceController?.setAmount(v);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  isNotEmpty(apiServiceController?.amount)
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
                                  "${amountFormatter(apiServiceController?.amount)}",
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
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  EPButton(
                    loading:
                        apiServiceController?.pageState == PageState.loading,
                    title: "Continue",
                    onTap: () {
                      onPinVerification();
                    },
                  ),
                ],
              ),
            ));
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
  onFailNumberVerify(String message) {}

  @override
  onPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        onTransfer();
      } else {
        onError(message);
      }
    });
  }

  @override
  onPreview() {}

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  onTransfer() {
    apiServiceController?.fundService();
  }
}
