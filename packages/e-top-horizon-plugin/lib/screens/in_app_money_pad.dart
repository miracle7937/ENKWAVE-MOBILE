import 'package:flutter/material.dart';

import '../constant/color.dart';
import '../reuseable_widget/cards.dart';
import '../reuseable_widget/custom_scaffold.dart';

class InAppPOSAccountSelectionScreen extends StatefulWidget {
  final Function(String) onSelectAccountType;
  const InAppPOSAccountSelectionScreen({
    Key? key,
    required this.onSelectAccountType,
  }) : super(key: key);

  @override
  State<InAppPOSAccountSelectionScreen> createState() =>
      _InAppPOSAccountSelectionScreenState();
}

class _InAppPOSAccountSelectionScreenState
    extends State<InAppPOSAccountSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(
          backgroundColor: EPColors.appMainColor,
          title: const Text("Account Type"),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            children: [
              CardWidget(
                  value: "00",
                  title: "Default Account",
                  callback: (v) {
                    widget.onSelectAccountType(v);
                    Navigator.pop(context);
                  }),
              CardWidget(
                value: "10",
                title: "Savings Account",
                callback: (v) {
                  widget.onSelectAccountType(v);
                  Navigator.pop(context);
                },
              ),
              CardWidget(
                value: "20",
                title: "Current Account",
                callback: (v) {
                  widget.onSelectAccountType(v);
                  Navigator.pop(context);
                },
              ),
              CardWidget(
                value: "30",
                title: "Corporate Account",
                callback: (v) {
                  widget.onSelectAccountType(v);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
