import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../Constant/string_values.dart';
import '../../../../DataLayer/controllers/update_account_controller.dart';
import '../../../../DataLayer/model/bank_list_response.dart';
import '../../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../transfers/widget/pin_verification_dialog.dart';

class UpdateAccountScreen extends StatefulWidget {
  final VoidCallback? refresh;
  const UpdateAccountScreen({Key? key, this.refresh}) : super(key: key);

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen>
    with UpdateAccountView {
  UpdateAccountController? _controller;
  @override
  void dispose() {
    _controller?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<UpdateAccountController>(context)
      ..getListOFBank()
      ..setUpdateAccountView(this);
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "UPDATE ACCOUNT INFORMATION",
        ),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Update your bank information",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          EPDropdownButton<Bank>(
              itemsListTitle: "Select Bank",
              iconSize: 22,
              value: _controller?.selectedBank,
              hint: const Text(""),
              isExpanded: true,
              underline: const Divider(),
              searchMatcher: (item, text) {
                return item.bankName!
                    .toLowerCase()
                    .contains(text.toLowerCase());
              },
              onChanged: (v) {
                _controller?.setBank = v;
                setState(() {});
              },
              items: (_controller?.listOfBank ?? [])
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.bankName.toString(),
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
                  hintText: "Account number",
                  enabledBorderColor: EPColors.appGreyColor,
                  keyboardType: TextInputType.number,
                  onChange: (v) {
                    _controller?.accountNumber = v;
                  },
                ),
              ),
              Expanded(
                child: EPButton(
                  title: "Verify",
                  onTap: () {
                    _controller?.bankAccountVerification();
                  },
                ),
              ),
            ],
          ),
          isNotEmpty(_controller?.accountName)
              ? ContainButton(
                  bgColor: EPColors.appMainColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          (_controller?.accountName ?? ""),
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
          const SizedBox(
            height: 20,
          ),
          EPButton(
            loading: _controller?.pageState == PageState.loading,
            title: "Continue",
            onTap: () {
              _controller?.onPinVerification();
            },
          )
        ],
      ),
    );
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
      widget.refresh!();
    });
  }

  @override
  onPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        _controller?.updateAccount();
      } else {
        onError(message);
      }
    });
  }
}
