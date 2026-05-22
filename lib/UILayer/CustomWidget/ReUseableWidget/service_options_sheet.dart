import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/cable_tv/cable_tv_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/electricity/electricity_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_in_app.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_to_other_bank.dart';
import 'package:enk_pay_project/UILayer/utils/screen_navigation.dart';
import 'package:flutter/material.dart';

class ServiceOption {
  final IconData? icon;
  final String? imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ServiceOption({
    this.icon,
    this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : assert(icon != null || imageAsset != null);
}

void showServiceOptionsSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  required List<ServiceOption> options,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: sheetContext.cardFill,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: sheetContext.mutedText.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                            color: sheetContext.mutedText,
                            fontSize: 13,
                          ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ...options.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ServiceOptionTile(option: option, sheetContext: sheetContext),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showTransferOptionsSheet(BuildContext context) {
  showServiceOptionsSheet(
    context,
    title: 'Transfer',
    subtitle: 'Choose how you want to send money',
    options: [
      ServiceOption(
        icon: Icons.account_balance_rounded,
        title: 'Bank transfer',
        subtitle: 'Send to any Nigerian bank account',
        onTap: () {
          Navigator.pop(context);
          pushToNextScreen(context, const TransferToOtherBank());
        },
      ),
      ServiceOption(
        icon: Icons.people_alt_rounded,
        title: 'Inapp transfer',
        subtitle: 'Transfer to another app user',
        onTap: () {
          Navigator.pop(context);
          pushToNextScreen(context, const TransferInApp());
        },
      ),
    ],
  );
}

void showBillPaymentOptionsSheet(BuildContext context) {
  showServiceOptionsSheet(
    context,
    title: 'Pay bills',
    subtitle: 'What would you like to pay?',
    options: [
      ServiceOption(
        imageAsset: EPImages.cableTv,
        title: 'Cable TV',
        subtitle: 'Pay DSTV, GOtv and more',
        onTap: () {
          Navigator.pop(context);
          pushToNextScreen(context, const CableTVScreen());
        },
      ),
      ServiceOption(
        imageAsset: EPImages.electricityIcon,
        title: 'Electricity',
        subtitle: 'Pay electricity bills instantly',
        onTap: () {
          Navigator.pop(context);
          pushToNextScreen(context, const ElectricityScreen());
        },
      ),
    ],
  );
}

class _ServiceOptionTile extends StatelessWidget {
  final ServiceOption option;
  final BuildContext sheetContext;

  const _ServiceOptionTile({
    required this.option,
    required this.sheetContext,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: sheetContext.cardFill,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: sheetContext.borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: EPColors.appMainColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: option.imageAsset != null
                      ? Image.asset(option.imageAsset!, fit: BoxFit.contain)
                      : Icon(option.icon, color: EPColors.appMainColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: Theme.of(sheetContext).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        option.subtitle,
                        style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                              color: sheetContext.mutedText,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: sheetContext.mutedText,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
