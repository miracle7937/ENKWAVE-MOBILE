import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constant/page_state.dart';
import '../utils/images.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final PageState? pageState;
  final AppBar? appBar;
  const CustomScaffold(
      {Key? key, required this.child, this.pageState, this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    if (pageState == null || pageState == PageState.loaded) {
      widget = child;
    } else if (pageState == PageState.isLoading) {
      widget = Center(
          child: SizedBox(
        width: 80,
        height: 80,
        child: Lottie.asset(
          Images.loader,
        ),
      ));
    } else if (pageState == PageState.error) {
      widget = const Center(
        child: Text("Error occured"),
      );
    }

    return SafeArea(
        child: Scaffold(
      appBar: appBar,
      key: key,
      body: widget,
    ));
  }
}
