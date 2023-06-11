import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/controllers/vcard_controller.dart';
import '../../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../../CustomWidget/ReUseableWidget/ep_button.dart';
import 'card_info_sheet_view.dart';

cardTransactionView(BuildContext context,
    {required String title,
    required Function(String) onChange,
    required VoidCallback onTap,
    bool fundWallet = true}) {
  return baseViewDialog(
      context,
      _Body(
        title: title,
        onChange: onChange,
        onTap: onTap,
        fundWallet: fundWallet,
      ));
}

class _Body extends StatefulWidget {
  final String title;
  final Function(String) onChange;
  final VoidCallback onTap;
  final bool fundWallet;
  const _Body(
      {Key? key,
      required this.title,
      required this.onChange,
      required this.onTap,
      required this.fundWallet})
      : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late VCardController vCardController;

  @override
  void dispose() {
    vCardController.clearAmount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    vCardController = Provider.of<VCardController>(
      context,
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          EPForm(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChange: (v) => widget.onChange(v),
            enabledBorderColor: EPColors.appGreyColor,
            hintText: "Amount to fund (USD)",
          ),
          Text(
            "Total Amount in NGN ",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          widget.fundWallet
              ? Text(
                  "NGN  ${vCardController.fundAmount ?? 0} ",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              : Text(
                  "NGN  ${vCardController.liquidateAmount ?? 0} ",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
          EPButton(
            title: "Continue",
            onTap: () {
              Navigator.pop(context);
              widget.onTap();
            },
          ),
        ],
      ),
    );
  }
}
