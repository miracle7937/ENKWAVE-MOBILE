import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/cash_out_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/transfer_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/services/music_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'DataLayer/LocalData/local_data_storage.dart';
import 'DataLayer/controllers/account_verification_controller.dart';
import 'DataLayer/controllers/api_service_controller.dart';
import 'DataLayer/controllers/auth_controller.dart';
import 'DataLayer/controllers/beneficiary_controller.dart';
import 'DataLayer/controllers/business_controller.dart';
import 'DataLayer/controllers/buy_airtime_controller.dart';
import 'DataLayer/controllers/cable_tv_controller.dart';
import 'DataLayer/controllers/contact_us_controller.dart';
import 'DataLayer/controllers/dashboard_controller.dart';
import 'DataLayer/controllers/electric_company_controller.dart';
import 'DataLayer/controllers/email_phone_verification_controller.dart';
import 'DataLayer/controllers/in_app_transfer_controller.dart';
import 'DataLayer/controllers/manage_terminal_controller.dart';
import 'DataLayer/controllers/mobile_data_controller.dart';
import 'DataLayer/controllers/network_data_controller.dart';
import 'DataLayer/controllers/pin_controller.dart';
import 'DataLayer/controllers/profile_controller.dart';
import 'DataLayer/controllers/request_device_controller.dart';
import 'DataLayer/controllers/set_pin_controller.dart';
import 'DataLayer/controllers/signin_controller.dart';
import 'DataLayer/controllers/transfer_status_controller.dart';
import 'DataLayer/controllers/update_account_controller.dart';
import 'DataLayer/controllers/vcard_controller.dart';
import 'DataLayer/model/login_response_model.dart';
import 'UILayer/Screens/AuthScreen/sign_in.dart';
import 'UILayer/Screens/Intro_Screen/onboarding_screen.dart';
import 'UILayer/Screens/main_screens/splash_screen.dart';
import 'UILayer/utils/account_creation_dialog.dart';
import 'UILayer/utils/key_pad.dart';
import 'UILayer/utils/loader_widget.dart';
import 'UILayer/utils/location_controller.dart';
import 'UILayer/utils/primary_swatch_color.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
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
        size: Size(100, 700),
      ),
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, w) => const ThemeWidget()),
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
        ChangeNotifierProvider<CableTVController>(
            create: (_) => CableTVController()),
        ChangeNotifierProvider<SignInController>(
            create: (_) => SignInController()),
        ChangeNotifierProvider<PinVerificationController>(
            create: (_) => PinVerificationController()),
        ChangeNotifierProvider<ElectricCompanyController>(
            create: (_) => ElectricCompanyController()),
        ChangeNotifierProvider<ProfileController>(
            create: (_) => ProfileController()),
        ChangeNotifierProvider<BusinessController>(
            create: (_) => BusinessController()),
        ChangeNotifierProvider<ContactUsController>(
            create: (_) => ContactUsController()),
        ChangeNotifierProvider<RequestDeviceController>(
            create: (_) => RequestDeviceController()),
        ChangeNotifierProvider<UpdateAccountController>(
            create: (_) => UpdateAccountController()),
        ChangeNotifierProvider<AccountVerificationController>(
            create: (_) => AccountVerificationController()),
        ChangeNotifierProvider<CashOutController>(
            create: (_) => CashOutController()),
        ChangeNotifierProvider<EmailPhoneVerificationController>(
            create: (_) => EmailPhoneVerificationController()),
        ChangeNotifierProvider<TransferStatusController>(
            create: (_) => TransferStatusController()),
        ChangeNotifierProvider<ManageTerminalController>(
            create: (_) => ManageTerminalController()),
        ChangeNotifierProvider<VCardController>(
            create: (_) => VCardController()),
        ChangeNotifierProvider<ApiServiceController>(
            create: (_) => ApiServiceController()),
        ChangeNotifierProvider<BeneficiaryController>(
            create: (_) => BeneficiaryController()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        routes: {
          '/signInScreen': (context) => const SignInScreen(),
          '/pinSignIn': (context) => const PinCodeWidget(),
        },
        builder: (context, widget) {
          ScreenUtil.init(context);
          return widget!;
        },
        title: 'EnkPay',
        theme: ThemeData(
          fontFamily: "Effra",
          appBarTheme: AppBarTheme(color: EPColors.appMainColor),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.pressed)) {
                return EPColors.appGreyColor;
              }
              return EPColors.appMainColor;
            }),
          )),
          primarySwatch: PrimarySwatchColor.get(),
          textTheme: getTextTheme(),
          toggleableActiveColor: EPColors.appMainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
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
  bool? isLocationEnable;
  @override
  void initState() {
    super.initState();

    try {
      checkLocation();
      firesBaseSetUp();
    } catch (e) {
      log(e.toString());
    }
  }

  checkLocation() async {
    isLocationEnable = await LocationController().determinePosition();
    if (isLocationEnable == false) {}
    setState(() {});
  }

  firesBaseSetUp() async {
    log("Initialize Firebase");
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      log("${androidInfo.model} Device");
      if (androidInfo.model == "TPS900") {
        return;
      }
    }
    var token = await FirebaseMessaging.instance.getToken();
    log("Firebase Token $token");
    // updateDeviceID(fcmToken!);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      MusicService().playAudioOnce();
      log(event.data.toString());
      if (event.data.isNotEmpty) {
        alertIncomeTransfer(
          NavigationService.navigatorKey.currentContext!,
          amount: event.data["amount"],
          name: event.data["sender_name"],
          bank: event.data["sender_bank"],
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  @override
  Widget build(BuildContext context) {
    // return const VCardRequestScreen();

    // return AuthPinScreen();
    return FutureBuilder<UserData?>(
        future: LocalDataStorage.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EPScaffold(
              builder: (_) => const LoaderWidget(),
            );
          }
          if (snapshot.data == null) {
            return const OnBoardingScreen();
          } else {
            // return const SignInScreen();
            return const PinCodeWidget();
          }
        });
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
