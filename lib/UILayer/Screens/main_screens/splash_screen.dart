import 'dart:async';

import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:enk_pay_project/UILayer/Screens/whitelabel/org_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/image.dart';
import '../../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final branding = context.read<BrandingController>();
      final next = branding.hasOrganization
          ? const MyHomePage(title: 'Agency Banking')
          : const OrgSelectScreen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => next),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? context.surfaceFill : EPColors.appMainColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.surfaceFill,
                    EPColors.appMainDark,
                  ],
                )
              : null,
          color: isDark ? null : EPColors.appMainColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              final logo =
                  context.watch<BrandingController>().branding?.logoUrl;
              if (logo != null && logo.isNotEmpty) {
                return Image.network(logo, height: 72, fit: BoxFit.contain);
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Image.asset(EPImages.testIcon),
                ),
              );
            }),
            const SizedBox(height: 32),
            LoaderIndicator(
              size: 40,
              color: isDark ? EPColors.appMainLightColor : Colors.white,
              trackColor: isDark
                  ? EPColors.appMainColor.withValues(alpha: 0.25)
                  : Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}
