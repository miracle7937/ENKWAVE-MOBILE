import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Constant/image.dart';
import '../CustomWidget/ReUseableWidget/ep_button.dart';
import '../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';

class StatusScreen extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  const StatusScreen({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      builder: (context) => Column(
        children: [
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Lottie.asset(
              EPImages.successJson,
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          ),
          // const Spacer(),
          Text(
            title ?? "Your entries have been successfully submitted",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Colors.black,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          EPButton(
            title: "OK",
            onTap: onTap,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
