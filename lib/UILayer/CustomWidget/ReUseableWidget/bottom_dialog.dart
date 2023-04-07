import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selection_listBottom_sheet.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_multi_formatter/formatters/formatter_extension_methods.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/money_formatter.dart';

_createDialogWidget(
  BuildContext context,
  String title,
  String message,
  String buttonText,
  VoidCallback callback, {
  String? image,
  String? flareAsset,
  bool displayAd = false,
}) {
  assert(!isEmpty(title));
  assert(!isEmpty(message));
  assert(!isEmpty(buttonText));
  return _createExtensibleDialogWidget(
      ListBody(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                height: 4,
                width: 70,
                color: Colors.black12,
              ),
            ),
          ),
          Visibility(
            visible: isNotEmpty(flareAsset) || isNotEmpty(image),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: SizedBox(
                width: 100,
                height: 100,
                child: isNotEmpty(flareAsset)
                    ? FlareActor(
                        flareAsset,
                        animation: "Animation",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        image!,
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: EPColors.appBlackColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              key: Key(message),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: EPColors.appBlackColor,
                  ),
            ),
          )),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          ),
          EPButton(
            title: buttonText,
            onTap: callback,
            key: const Key('continue_button'),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
          )
        ],
      ),
      borderRadius: BorderRadius.circular(15));
}

Future showBottomSheetDialog<T>(
  BuildContext context, {
  String? title,
  String? message,
  String? buttonText,
  VoidCallback? callback,
  String? icon,
  String? flareAsset,
  bool dismissible = true,
  bool displayAd = false,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: dismissible,
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return GestureDetector(
            child: _createDialogWidget(
          context,
          title!,
          message!,
          buttonText!,
          callback ?? () {},
          image: icon,
          flareAsset: flareAsset,
          displayAd: displayAd,
        ));
      });
}

Future<void> showEPStatusDialog(BuildContext context,
    {bool success = true,
    VoidCallback? callback,
    String? btnText,
    String? title,
    String? message,
    bool dismissible = true}) {
  return showBottomSheetDialog(
    context,
    dismissible: dismissible,
    title: title ?? (success ? "Success" : "Error"),
    flareAsset: success ? EPImages.successAnimation : EPImages.errorAnimation,
    message: message,
    buttonText: btnText ?? "Done",
    callback: callback,
    displayAd: true,
    isScrollControlled: true,
  );
}

_createExtensibleDialogWidget(
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

Future<T?>? showIVBottomSheetList<T>({
  Key? key,
  required BuildContext context,
  required List<T> items,
  Future<List<T>>? itemsFuture,
  required Widget Function(T) itemBuilder,
  required ValueChanged<T> onItemSelected,
  String? title,
  bool hasSearch = false,
  bool Function(T, String)? searchMatcher,
  bool? shouldPop = true,
  String? searchHint,
  String? noDataMessage,
  Color seperatorColor = const Color(0xffEFEFEF),
  Map<String, SegregationFunction<T>>? segregationMap,
  TextStyle? defaultSegregationTitleStyle,
  EdgeInsets? segregationTitlePadding,
  Map<String, TextStyle>? segregationTitlesStylesMap,
  bool hideSegregationTitle = false,
  String? favoriteTitle,
  List<T>? favoriteItems,
  String Function(T item)? favItemBuilder,
}) {
  return showIVModalBottomSheet<T>(
    context: context,
    isDismissible: true,
    // expand: true,
    body: SelectionListBottomSheet<T>(
      title: title ?? '',
      items: items,
      itemsFuture: itemsFuture,
      itemBuilder: itemBuilder,
      onItemSelected: onItemSelected,
      hasSearch: hasSearch,
      searchMatcher: searchMatcher,
      shouldPop: shouldPop!,
      searchHint: searchHint,
      noDataMessage: noDataMessage,
      seperatorColor: seperatorColor,
      segregationMap: segregationMap,
      defaultSegregationTitleStyle: defaultSegregationTitleStyle,
      segregationTitlePadding: segregationTitlePadding,
      segregationTitlesStylesMap: segregationTitlesStylesMap,
      hideSegregationTitle: hideSegregationTitle,
      favoritesTitle: favoriteTitle,
      favoriteItems: favoriteItems,
      favItemBuilder: favItemBuilder,
    ),
  );
}

void showListOFDataPackage(BuildContext context, List<BasePackage>? recipients,
    ValueChanged<BasePackage> valueChanged) {
  showIVBottomSheetList<BasePackage>(
    hasSearch: true,
    searchMatcher: (BasePackage recipient, String b) {
      return [
        recipient.getAmount,
        recipient.getDesc,
      ].any((String? it) => it!.contains(b));
    },
    title: "Mobile Data",
    context: context,
    items: recipients!,
    itemBuilder: (BasePackage r) {
      //${r.phones.first.number.toString()}
      return DropdownMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                "${r.getDesc} ",
                style: Theme.of(context).textTheme.headline4,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "NGN${double.parse(r.getAmount!).toCurrencyString(mantissaLength: 0).toString()} ",
                  style: Theme.of(context).textTheme.button,
                ),
              ],
            ),
          ],
        ),
      );
    },
    onItemSelected: valueChanged,
  );
}

void showPhoneList(BuildContext context, List<Contact> recipients,
    ValueChanged<Contact> valueChanged) {
  showIVBottomSheetList<Contact>(
    hasSearch: true,
    searchMatcher: (Contact recipient, String b) {
      return [
        recipient.displayName,
      ].any((String? it) => it!.contains(b));
    },
    title: "Mobile Number",
    context: context,
    items: recipients,
    itemBuilder: (Contact r) {
      //${r.phones.first.number.toString()}
      return DropdownMenuItem(
        child: Text(
          "${r.displayName} ",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    },
    onItemSelected: valueChanged,
  );
}

void showBankList(BuildContext context, List<Bank> listOfBanks,
    ValueChanged<Bank> valueChanged) {
  showIVBottomSheetList<Bank>(
    hasSearch: true,
    searchMatcher: (Bank bank, String b) {
      return [
        bank.bankName,
      ].any((String? it) => it!.toLowerCase().contains(b.toLowerCase()));
    },
    title: "Mobile Number",
    context: context,
    items: listOfBanks,
    itemBuilder: (Bank r) {
      return DropdownMenuItem(
        child: Text("${r.bankName} ",
            style: Theme.of(context).textTheme.headline3!.copyWith(
                fontWeight: FontWeight.bold, color: EPColors.appBlackColor)),
      );
    },
    onItemSelected: valueChanged,
  );
}

void showWalletList(BuildContext context, List<UserWallet> listOfBanks,
    ValueChanged<UserWallet> valueChanged) {
  showIVBottomSheetList<UserWallet>(
    hasSearch: true,
    searchMatcher: (UserWallet bank, String b) {
      return [
        bank.title,
      ].any((String? it) => it!.toLowerCase().contains(b.toLowerCase()));
    },
    title: "Mobile Number",
    context: context,
    items: listOfBanks,
    itemBuilder: (UserWallet wallet) {
      return DropdownMenuItem(
        child: Row(
          children: [
            Text(wallet.title.toString(),
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: EPColors.appBlackColor)),
            const Spacer(),
            Text(amountFormatter(wallet.amount.toString()),
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: EPColors.appBlackColor)),
          ],
        ),
      );
    },
    onItemSelected: valueChanged,
  );
}

Future<T?>? showIVModalBottomSheet<T>({
  required BuildContext context,
  required Widget body,
  bool expand = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  Color? barrierColor,
  bool enableDrag = true,
  AnimationController? secondAnimation,
  bool bounce = false,
  Duration duration = const Duration(milliseconds: 400),
  double closeProgressThreshold = 0.6,
  Radius topRadius = const Radius.circular(12),
}) {
  return showCupertinoModalBottomSheet<T>(
    context: context,
    expand: expand,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    barrierColor: barrierColor,
    enableDrag: enableDrag,
    secondAnimation: secondAnimation,
    bounce: bounce,
    duration: duration,
    closeProgressThreshold: closeProgressThreshold,
    backgroundColor: EPColors.appMainColor,
    topRadius: topRadius,
    builder: (context) {
      return Material(
        child: body,
        //use  controller: ModalScrollController.of(context), in the body for closing while scrolling
      );
    },
  );
}

pinDialog(BuildContext context,
    {required Widget body, String? message, VoidCallback? onTap}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return _createExtensibleDialogWidget(
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
              body,
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
