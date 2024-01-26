import 'dart:async';

import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

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
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Enkpay'))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: EPColors.appMainColor),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.asset(EPImages.testIcon)),
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(color: EPColors.appBlackColor),
    );
  }
}
