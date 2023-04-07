import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/grey_bg_card.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/request_device_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ReUseableWidget/snack_bar.dart';
import '../../utils/status_screen.dart';

class DeviceOrderPayment extends StatefulWidget {
  const DeviceOrderPayment({Key? key}) : super(key: key);

  @override
  State<DeviceOrderPayment> createState() => _DeviceOrderPaymentState();
}

class _DeviceOrderPaymentState extends State<DeviceOrderPayment>
    with OrderDeviceView {
  RequestDeviceController? _controller;
  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<RequestDeviceController>(context)
      ..setRequestCompleteView(this);
    return EPScaffold(
      state: AppState(pageState: _controller?.pageState),
      appBar: EPAppBar(title: const Text("MAKE PAYMENT")),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            "Device Amount",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GreyBGCard(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            child: _tile("POS  Terminal",
                amountFormatter(_controller?.requestDeviceResponse?.amount)),
          )),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Account Information",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GreyBGCard(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            child: Column(
              children: [
                _tile("Account Number",
                    _controller?.requestDeviceResponse?.bank?.accountNo,
                    copy: true),
                _tile("Account Name",
                    _controller?.requestDeviceResponse?.bank?.accountName),
                _tile("Bank Name",
                    _controller?.requestDeviceResponse?.bank?.bankName),
                _tile("Payment Ref",
                    _controller?.requestDeviceResponse?.paymentRef,
                    copy: true),
              ],
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Note: Please add the Payment Ref to the transaction description.",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          EPButton(
            title: "I’VE MADE PAYMENT",
            onTap: () {
              _controller?.orderDeviceComplete();
            },
          )
        ],
      ),
    );
  }

  _tile(String title, value, {copy = false}) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                title,
                style: TextStyle(
                  color: EPColors.appBlackColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: TextStyle(
                        color: EPColors.appBlackColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  copy
                      ? InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: value))
                                .then((value) {
                              snackBar(context, message: "$title copied");
                            });
                          },
                          child: Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              FaIcon(FontAwesomeIcons.copy),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
        const Divider()
      ],
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => StatusScreen(
                  title: message,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )));
  }
}
