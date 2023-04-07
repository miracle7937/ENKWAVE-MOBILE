import 'package:flutter/material.dart';

import '../selection_listBottom_sheet.dart';
import 'cupertino_bottom_sheet.dart';

Future<T?> showBottomSheetList<T>({
  Key? key,
  required BuildContext context,
  List<T>? items,
  Future<List<T>>? itemsFuture,
  required Widget Function(T)? itemBuilder,
  required ValueChanged<T>? onItemSelected,
  String? title,
  bool hasSearch = false,
  bool Function(T, String)? searchMatcher,
  bool? shouldPop,
  String? searchHint,
  String? noDataMessage,
  Color seperatorColor = const Color(0xffEFEFEF),
  Map<String, SegregationFunction<T>>? segregationMap,
  TextStyle? defaultSegregationTitleStyle,
  EdgeInsets? segregationTitlePadding,
  Map<String, TextStyle>? segregationTitlesStylesMap,
  bool hideSegregationTitle = false,
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
    ),
  );
}

Future<T?> showIVModalBottomSheet<T>({
  required BuildContext context,
  Widget? body,
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
    backgroundColor: Colors.white,
    topRadius: topRadius,
    builder: (context) {
      return Material(
        child: body,
        //use  controller: ModalScrollController.of(context), in the body for closing while scrolling
      );
    },
  );
}
