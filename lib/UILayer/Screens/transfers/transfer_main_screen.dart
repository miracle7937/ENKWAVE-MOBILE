import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_in_app.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_to_other_bank.dart';
import 'package:enk_pay_project/UILayer/utils/screen_navigation.dart';
import 'package:flutter/material.dart';

class TransfersMainScreen extends StatelessWidget {
  const TransfersMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(title: const Text('Transfer')),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'Choose transfer type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Send to any bank or to another app user',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.mutedText,
                  ),
            ),
            const SizedBox(height: 20),
            _TransferOptionTile(
              icon: Icons.account_balance_rounded,
              title: 'Bank transfer',
              subtitle: 'Send to any Nigerian bank account',
              onTap: () => pushToNextScreen(context, const TransferToOtherBank()),
            ),
            const SizedBox(height: 12),
            _TransferOptionTile(
              icon: Icons.people_alt_rounded,
              title: 'Inapp transfer',
              subtitle: 'Transfer to another app user',
              onTap: () => pushToNextScreen(context, const TransferInApp()),
            ),
          ],
        );
      },
    );
  }
}

class _TransferOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TransferOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardFill,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: EPColors.appMainColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: EPColors.appMainColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.mutedText,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.mutedText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
