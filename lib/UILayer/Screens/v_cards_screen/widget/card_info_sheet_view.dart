import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/model/card_details_model.dart';
import '../../../CustomWidget/ReUseableWidget/snack_bar.dart';

cardInfoView(BuildContext context, CardDetails? cardDetails) {
  return baseViewDialog(
      context,
      Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Card Information",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            _view(context, title: "Address", value: cardDetails?.address ?? ""),
            _view(context, title: "City", value: cardDetails?.city ?? ""),
            _view(context,
                title: "Zip Code", value: cardDetails?.zipCode ?? ""),
          ],
        ),
      ));
}

_view(BuildContext context, {String? title, String? value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? "",
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
      ),
      Row(
        children: [
          Text(
            value ?? "",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value ?? "")).then((value) {
                snackBar(context, message: "copied");
                Navigator.pop(context);
              });
            },
            child: const FaIcon(
              FontAwesomeIcons.copy,
            ),
          ),
        ],
      ),
      Divider(),
    ],
  );
}

baseViewDialog(BuildContext context, Widget child, {bool isScrollControlled=true}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    isScrollControlled: isScrollControlled,
    context: context,
    builder: (context) {
      return createExtensibleDialogWidget(
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  height: 5,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              child,
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const SizedBox(
                  height: 15,
                ),
              )
            ],
          ),
        ),
        padding: const EdgeInsets.all(10),
      );
    },
  );
}

createExtensibleDialogWidget(
  Widget body, {
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry? padding,
}) {
  return SafeArea(
    child: Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: EPColors.appWhiteColor,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius ??
              const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
        ),
        child: SingleChildScrollView(
          child: body,
        ),
      ),
    ),
  );
}
