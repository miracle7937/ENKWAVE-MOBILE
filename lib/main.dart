import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/transfer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'DataLayer/controllers/auth_controller.dart';
import 'DataLayer/controllers/buy_airtime_controller.dart';
import 'DataLayer/controllers/dashboard_controller.dart';
import 'DataLayer/controllers/in_app_transfer_controller.dart';
import 'DataLayer/controllers/mobile_data_controller.dart';
import 'DataLayer/controllers/network_data_controller.dart';
import 'DataLayer/controllers/set_pin_controller.dart';
import 'UILayer/Screens/Intro_Screen/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return MediaQuery(
      //Setting font does not change with system font size
      data: const MediaQueryData(
        size: Size(1000, 700),
      ),
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: () => const ThemeWidget()),
    );
  }
  // // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return ScreenUtilInit(
  //     designSize: const Size(360, 690),
  //     builder: () {
  //       return const ThemeWidget();
  //     },
  //   );
  // }
}

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<TransferController>(
            create: (_) => TransferController()),
        ChangeNotifierProvider<InAppTransferController>(
            create: (_) => InAppTransferController()),
        ChangeNotifierProvider<PinController>(create: (_) => PinController()),
        ChangeNotifierProvider<NetworkDataController>(
            create: (_) => NetworkDataController()),
        ChangeNotifierProvider<DashBoardController>(
            create: (_) => DashBoardController()),
        ChangeNotifierProvider<AirtimeController>(
            create: (_) => AirtimeController()),
        ChangeNotifierProvider<MobileDataController>(
            create: (_) => MobileDataController()),
      ],
      child: MaterialApp(
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return widget!;
        },
        title: 'EnkPay',
        theme: ThemeData(
          fontFamily: "Effra",
          elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.pressed)) {
                return EPColors.appGreyColor;
              }
              return EPColors.appMainColor;
            }),
          )),
          primarySwatch: Colors.red,
          textTheme: getTextTheme(),
          toggleableActiveColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(title: 'Enkpay'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return OTPScreen();
    // return TransfersMainScreen();
    return const OnBoardingScreen();
  }
}

TextTheme getTextTheme() {
  return TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 26.sp,
    ),
    headline3: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10.sp,
    ),
    headline5: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.sp,
    ),
    headline6: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 7.sp,
    ),
    bodyText2: TextStyle(
      fontSize: 30.sp,
    ),
    bodyText1: TextStyle(
      fontSize: 12.sp,
    ),
    caption: TextStyle(
      fontSize: 50.sp,
    ),
    overline: TextStyle(
      fontSize: 45.sp,
    ),
    button: const TextStyle(
      fontSize: 14,
    ),
  );
}
