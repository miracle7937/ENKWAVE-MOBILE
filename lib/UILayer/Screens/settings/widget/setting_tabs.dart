import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../../Constant/colors.dart';

class SettingTabs extends StatelessWidget {
  final String image, title;
  final VoidCallback? onTap;

  const SettingTabs({
    Key? key,
    required this.image,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        color: context.cardFill,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.surfaceFill,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.primaryText,
                        ),
                  ),
                ),
                Icon(Icons.chevron_right, color: EPColors.appMuted, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
