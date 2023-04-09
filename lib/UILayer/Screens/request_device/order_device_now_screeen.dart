import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/request_device_controller.dart';
import '../../../DataLayer/model/location_response.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../../utils/linear_progress_bar.dart';
import 'device_ordrer_payment.dart';

class OrderDeviceScreen extends StatefulWidget {
  const OrderDeviceScreen({Key? key}) : super(key: key);

  @override
  State<OrderDeviceScreen> createState() => _OrderDeviceScreenState();
}

class _OrderDeviceScreenState extends State<OrderDeviceScreen>
    with RequestDeviceView {
  RequestDeviceController? _controller;
  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<RequestDeviceController>(context)
      ..setRequestDeviceView(this)
      ..getAllLocation();
    return EPScaffold(
        appBar: EPAppBar(
          title: const Text("ORDER DEVICE"),
        ),
        builder: (_) => SingleChildScrollView(
              child: Column(
                children: [
                  EPLinearProgressBar(
                    loading: _controller?.isLoading,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Device Information",
                    style: TextStyle(
                      color: EPColors.appBlackColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  EPForm(
                    hintText: "Full Name",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.text,
                    onChange: (v) {
                      _controller?.requestDevicePerson.fullname = v;
                    },
                  ),
                  EPForm(
                    hintText: "Address",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.text,
                    onChange: (v) {
                      _controller?.requestDevicePerson.address = v;
                    },
                  ),
                  EPDropdownButton<LocationData>(
                      itemsListTitle: "Select State",
                      iconSize: 22,
                      value: _controller?.location,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.name!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        _controller?.setNGState = v;
                      },
                      items: (_controller?.locationData ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: EPColors.appBlackColor))),
                          )
                          .toList()),
                  EPForm(
                    hintText: "Enter phone number",
                    enabledBorderColor: EPColors.appGreyColor,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChange: (v) {
                      _controller?.requestDevicePerson.phone = v;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EPButton(
                    loading: _controller?.pageState == PageState.loading,
                    title: "ORDER NOW",
                    onTap: () {
                      _controller?.requestDevice();
                    },
                  )
                ],
              ),
            ));
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
        context, MaterialPageRoute(builder: (_) => const DeviceOrderPayment()));
  }
}
