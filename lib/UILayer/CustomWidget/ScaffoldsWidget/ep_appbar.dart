import 'package:flutter/material.dart';

class EPAppBar extends AppBar {
  EPAppBar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double elevation = 0,
    Color? backgroundColor,
    Brightness? brightness,
    IconThemeData? iconTheme,
    TextTheme? textTheme,
    bool primary = true,
    bool? centerTitle,
    double? titleSpacing = NavigationToolbar.kMiddleSpacing,
    double toolbarOpacity = 1,
    double bottomOpacity = 1,
  }) : super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: title,
          actions: actions,
          flexibleSpace: flexibleSpace ??
              SafeArea(
                child: Container(
                  // height: 100,
                  decoration:
                      BoxDecoration(color: backgroundColor ?? Colors.white
                          // image: DecorationImage(
                          //   image: AssetImage(Images.appBarBanner),
                          //   fit: BoxFit.cover,
                          // ),
                          ),
                ),
              ),
          bottom: bottom,
          elevation: elevation,
          backgroundColor: backgroundColor,
          brightness: brightness,
          iconTheme: iconTheme ?? IconThemeData(),
          textTheme: textTheme ?? TextTheme(),
          primary: primary,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
        );
}
