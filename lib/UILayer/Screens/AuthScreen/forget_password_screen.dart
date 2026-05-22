import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/signin_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/widget/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with ForgetPasswordView {
  SignInController? controller;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<SignInController>(context)..forgetView = this;
    final scheme = Theme.of(context).colorScheme;

    return EPScaffold(
      backgroundColor: EPColors.appMainDark,
      state: AppState(pageState: controller?.pageState),
      padding: EdgeInsets.zero,
      builder: (context) => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ColoredBox(
          color: scheme.surface,
          child: Column(
        children: [
          AuthHeroHeader(
            title: 'Reset password',
            subtitle:
                'Enter the email linked to your account. We\'ll send reset instructions.',
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: AuthFormCard(
                children: [
                  AuthTextField(
                    label: 'Email address',
                    hintText: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: context.mutedText,
                      size: 20,
                    ),
                    onChanged: (v) => controller?.setEmail(v),
                  ),
                  const SizedBox(height: 4),
                  AuthPrimaryButton(
                    title: 'Send reset link',
                    onTap: () => controller?.forgetPassword(),
                  ),
                ],
              ),
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }

  @override
  onError(String massage) {
    showEPStatusDialog(context, success: false, message: massage, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String massage) {
    showEPStatusDialog(context, success: true, message: massage, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
