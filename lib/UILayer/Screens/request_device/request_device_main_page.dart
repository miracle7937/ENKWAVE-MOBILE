import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Constant/colors.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'order_device_now_screeen.dart';

class RequestDevicePage extends StatelessWidget {
  const RequestDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text("ORDER DEVICE"),
      ),
      builder: (_) => Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Device Information",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(EPImages.posRealDevice),
          const Spacer(),
          EPButton(
            title: "ORDER NOW",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OrderDeviceScreen()));
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
