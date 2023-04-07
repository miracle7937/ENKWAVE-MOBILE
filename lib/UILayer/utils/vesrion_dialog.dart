import 'dart:io';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CustomWidget/ReUseableWidget/ep_button.dart';

versionDialog(BuildContext context, {String? iosLink, String? androidLink}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('INFO'),
      content: Text(
        'An updated version of this app is available. Please proceed to install it.',
        style: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
      ),
      actions: [
        EPButton(
          title: "Proceed",
          onTap: () {
            if (Platform.isAndroid) {
              _launchUrl(androidLink);
            } else if (Platform.isIOS) {
              _launchUrl(iosLink);
            }
          },
        ),
      ],
    ),
  );
}

Future<void> _launchUrl(url) async {
  if (isEmpty(url)) {
    return;
  }
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw Exception('Could not launch $url');
  }
}
