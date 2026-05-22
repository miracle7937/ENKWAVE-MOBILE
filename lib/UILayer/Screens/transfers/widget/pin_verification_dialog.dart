import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../DataLayer/controllers/pin_controller.dart';
import '../../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../../utils/pin_input_widgets.dart';
import '../../settings/update_pin_screen.dart';

void showPinDialog(
  BuildContext context, {
  required void Function(bool status, String message, String pin) onVerification,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (_) => _TransferPinSheet(onVerification: onVerification),
  );
}

class _TransferPinSheet extends StatefulWidget {
  final void Function(bool status, String message, String pin)? onVerification;

  const _TransferPinSheet({this.onVerification});

  @override
  State<_TransferPinSheet> createState() => _TransferPinSheetState();
}

class _TransferPinSheetState extends State<_TransferPinSheet> with PinView {
  String _pin = '';
  late PinVerificationController _pinController;

  void _onDigit(String digit) {
    if (_pin.length >= 4 || _pinController.pageState == PageState.loading) {
      return;
    }
    setState(() => _pin += digit);
    if (_pin.length == 4) {
      _pinController.verifyPin(_pin);
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty || _pinController.pageState == PageState.loading) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _clearPin() {
    setState(() => _pin = '');
  }

  @override
  Widget build(BuildContext context) {
    _pinController = Provider.of<PinVerificationController>(context)
      ..setView = this;

    final scheme = Theme.of(context).colorScheme;
    final loading = _pinController.pageState == PageState.loading;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardFill,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: context.mutedText.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        EPColors.appMainColor.withValues(alpha: 0.15),
                        EPColors.appMainLightColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Image.asset(EPImages.pinLock, fit: BoxFit.contain),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter transfer PIN',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Confirm this transfer with your 4-digit PIN',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.mutedText,
                        fontSize: 12,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 24),
                PinDots(
                  length: 4,
                  filled: _pin.length,
                  activeColor: scheme.primary,
                  emptyColor: context.borderColor,
                  useBoxes: true,
                ),
                if (loading) ...[
                  const SizedBox(height: 16),
                  LoaderIndicator(
                    size: 28,
                    color: scheme.primary,
                    trackColor: scheme.primary.withValues(alpha: 0.15),
                  ),
                ] else
                  const SizedBox(height: 16),
                PinKeypad(
                  compact: true,
                  onDigit: _onDigit,
                  onBackspace: _onBackspace,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UpdatePinScreen(),
                            ),
                          );
                        },
                  child: Text(
                    'Forgot PIN?',
                    style: TextStyle(
                      color: EPColors.appMainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    _clearPin();
    widget.onVerification?.call(false, message, _pinController.pin ?? '');
  }

  @override
  void onSuccess(String message) {
    widget.onVerification?.call(true, message, _pinController.pin ?? '');
  }
}
