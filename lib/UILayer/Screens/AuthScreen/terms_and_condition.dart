import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return EPScaffold(
        builder: (_) => WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: AppRoute.termsAndCondition,
            ));
  }
}
