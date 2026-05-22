import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/controllers/signin_controller.dart';
import '../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../Screens/AuthScreen/sign_in.dart';
import '../Screens/main_screens/nav_ui.dart';
import 'pin_input_widgets.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({super.key});

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> with PinSignInView {
  String _enteredPin = '';
  late SignInController _signInController;

  void _onDigit(String digit) {
    if (_enteredPin.length >= 4) return;
    setState(() => _enteredPin += digit);
    if (_enteredPin.length == 4) {
      final pin = _enteredPin;
      _enteredPin = '';
      _signInController.pinSignIn(pin);
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    _signInController = Provider.of<SignInController>(context)..pinView = this;
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;

    return EPScaffold(
      state: AppState(pageState: _signInController.pageState),
      backgroundColor: scheme.surface,
      builder: (context) => SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: 'Sign in with password',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  );
                },
                icon: Icon(Icons.logout_rounded, color: onSurface),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxHeight < 520;
                    final lockSize = compact ? 56.0 : 72.0;
                    final lockPad = compact ? 12.0 : 16.0;

                    return Column(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: lockSize,
                                height: lockSize,
                                padding: EdgeInsets.all(lockPad),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.asset(
                                  EPImages.pinLock,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: compact ? 12 : 24),
                              Text(
                                'Enter your PIN',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: onSurface,
                                      letterSpacing: -0.3,
                                      fontSize: compact ? 20 : null,
                                    ),
                              ),
                              SizedBox(height: compact ? 4 : 8),
                              Text(
                                'Use your 4-digit security PIN',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: context.mutedText,
                                      fontSize: compact ? 13 : null,
                                    ),
                              ),
                              SizedBox(height: compact ? 16 : 28),
                              PinDots(
                                length: 4,
                                filled: _enteredPin.length,
                                activeColor: scheme.primary,
                                emptyColor: context.borderColor,
                              ),
                            ],
                          ),
                        ),
                        PinKeypad(
                          compact: compact,
                          onDigit: _onDigit,
                          onBackspace: _onBackspace,
                        ),
                        SizedBox(height: compact ? 8 : 24),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    setState(() => _enteredPin = '');
    showEPStatusDialog(context,
        success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(String message) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const NavUI()),
      (route) => false,
    );
  }
}
