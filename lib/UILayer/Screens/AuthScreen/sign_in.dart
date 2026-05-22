import 'dart:io';

import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/package_info.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/biomertic_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/signin_controller.dart';
import 'package:enk_pay_project/DataLayer/model/user_credential_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/device_reg/change_device_otp.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/forget_password_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/select_verification_method_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/widget/auth_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/main_screens/nav_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with LOGINView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late SignInController authController;
  bool isBiometricEnable = false;

  @override
  void initState() {
    super.initState();
    checkBiometric();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.initCredential();
      credentialInit();
    });
  }

  Future<void> credentialInit() async {
    final credential = await LocalDataStorage.getUserCredential();
    if (credential != null) {
      onSetUserCredential(credential);
    }
  }

  Future<void> checkBiometric() async {
    isBiometricEnable = await BiometricController.isBiometricEnable();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    authController = Provider.of<SignInController>(context)..view = this;
    final usePhone = authController.loginWithPhoneNumber;
    final scheme = Theme.of(context).colorScheme;

    return EPScaffold(
      backgroundColor: EPColors.appMainDark,
      state: AppState(pageState: authController.pageState),
      scaffoldKey: _scaffoldKey,
      padding: EdgeInsets.zero,
      builder: (context) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ColoredBox(
            color: scheme.surface,
            child: Column(
          children: [
            const AuthHeroHeader(
              title: 'Welcome back',
              subtitle: 'Sign in to manage your agency banking and POS.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const OrganizationContextBanner(),
                    const SizedBox(height: 12),
                    AuthFormCard(
                      children: [
                        if (usePhone)
                          AuthTextField(
                            label: 'Phone number',
                            hintText: 'Enter phone number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: context.mutedText,
                              size: 20,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: authController.setPhone,
                          )
                        else
                          AuthTextField(
                            label: 'Email',
                            hintText: 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.mail_outline_rounded,
                              color: context.mutedText,
                              size: 20,
                            ),
                            onChanged: authController.setEmail,
                          ),
                        AuthTextField(
                          label: 'Password',
                          hintText: 'Enter password',
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: context.mutedText,
                            size: 20,
                          ),
                          onChanged: authController.setPassword,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: EPColors.appMainColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AuthPrimaryButton(
                          title: 'Sign in',
                          onTap: authController.validateSIGNInForm,
                        ),
                      ],
                    ),
                    const AuthDividerLabel(),
                    AuthOutlineButton(
                      title: usePhone
                          ? 'Use email instead'
                          : 'Use phone number instead',
                      icon: usePhone
                          ? Icons.alternate_email_rounded
                          : Icons.phone_android_rounded,
                      onTap: () {
                        credentialInit();
                        authController.setLoginType(!usePhone);
                      },
                    ),
                    if (isBiometricEnable) ...[
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Quick sign in',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: context.mutedText,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AuthBiometricButton(
                              onTap: authController.biometricLogin,
                              icon: Image.asset(
                                Platform.isAndroid
                                    ? EPImages.fingerPrint
                                    : EPImages.faceID,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    AuthLinkRow(
                      prefix: 'No account yet? ',
                      action: 'Create account',
                      onAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SelectVerificationMethodScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Version ${PackageInfo().getVersion()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.mutedText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(v) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const NavUI()),
      (route) => false,
    );
  }

  @override
  void onValidate() {
    final branding = context.read<BrandingController>();
    final orgId = branding.branding?.businessId ?? '';
    if (!branding.hasOrganization || orgId.isEmpty) {
      onError('Select your organization code first (tap Choose on the banner).');
      return;
    }
    authController.logIn();
  }

  @override
  void onNewDevice(String message) {
    showChangeDeviceIdDialog(context, message: message, onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChangeDeviceOTPScreen()),
      );
    });
  }

  @override
  void onSetUserCredential(UserCredentialModel userCredentialModel) {
    _emailController.text = userCredentialModel.email ?? '';
    _phoneController.text = userCredentialModel.phone ?? '';
    setState(() {});
  }
}
