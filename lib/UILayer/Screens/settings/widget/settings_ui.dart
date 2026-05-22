import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/controllers/theme_controller.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsSectionLabel extends StatelessWidget {
  final String label;

  const SettingsSectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.mutedText,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontSize: 10,
              ),
        ),
      ),
    );
  }
}

class SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroupCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final dividerColor = context.isDarkMode
        ? const Color(0xFF3B2660)
        : EPColors.appBorder.withValues(alpha: 0.9);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: context.cardFill,
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderColor.withValues(alpha: 0.85),
            ),
            boxShadow: context.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: EPColors.appMainColor.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(height: 1, thickness: 1, indent: 58, color: dividerColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsMenuTile extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool destructive;
  final Widget? trailing;

  const SettingsMenuTile({
    super.key,
    this.image,
    this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.destructive = false,
    this.trailing,
  }) : assert(image != null || icon != null);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final titleColor =
        destructive ? EPColors.appDanger : scheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: destructive
                      ? EPColors.appDanger.withValues(alpha: 0.1)
                      : scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: icon != null
                    ? Icon(
                        icon,
                        color: destructive ? EPColors.appDanger : scheme.primary,
                        size: 18,
                      )
                    : Image.asset(
                        image!,
                        fit: BoxFit.contain,
                        color: destructive ? EPColors.appDanger : scheme.primary,
                        colorBlendMode: BlendMode.srcIn,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: titleColor,
                            fontSize: 13,
                            height: 1.2,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.mutedText,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: context.mutedText.withValues(alpha: 0.7),
                    size: 18,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsProfileCard extends StatelessWidget {
  final UserData? user;

  const SettingsProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Material(
        color: context.cardFill,
        elevation: 0,
        borderRadius: BorderRadius.circular(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.borderColor),
            boxShadow: context.isDarkMode ? null : EPColors.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        EPColors.appMainDark,
                        EPColors.appMainLightColor,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primary.withValues(alpha: 0.12),
                          border: Border.all(
                            color: scheme.primary.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          user?.isMale == true
                              ? Icons.person_outline_rounded
                              : Icons.person_2_outlined,
                          color: scheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isEmpty ? 'Account' : name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: scheme.onSurface,
                                    fontSize: 15,
                                    letterSpacing: -0.2,
                                    height: 1.2,
                                  ),
                            ),
                            if (_has(user?.email)) ...[
                              const SizedBox(height: 4),
                              _detailRow(
                                context,
                                Icons.mail_outline_rounded,
                                user!.email!,
                              ),
                            ],
                            if (_has(user?.addressLine1)) ...[
                              const SizedBox(height: 2),
                              _detailRow(
                                context,
                                Icons.location_on_outlined,
                                user!.addressLine1!,
                              ),
                            ],
                            if (_has(user?.serialNo)) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      scheme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        scheme.primary.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  'Terminal ${user!.serialNo}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _has(String? v) => isNotEmpty(v);

  Widget _detailRow(BuildContext context, IconData iconData, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(iconData, size: 12, color: context.mutedText),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.mutedText,
                  fontSize: 11,
                  height: 1.3,
                ),
          ),
        ),
      ],
    );
  }
}

class SettingsVerificationBanner extends StatelessWidget {
  final bool? isVerified;
  final VoidCallback? onTap;

  const SettingsVerificationBanner({
    super.key,
    this.isVerified,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final verified = isVerified == true;
    final bg = verified
        ? (context.isDarkMode
            ? const Color(0xFF0F2A1A)
            : const Color(0xFFECFDF5))
        : (context.isDarkMode
            ? const Color(0xFF2A1F0A)
            : const Color(0xFFFFFBEB));
    final border = verified
        ? EPColors.appSuccess.withValues(alpha: 0.35)
        : EPColors.appWarning.withValues(alpha: 0.35);
    final iconColor = verified ? EPColors.appSuccess : EPColors.appWarning;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: verified ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Icon(
                  verified
                      ? Icons.verified_user_rounded
                      : Icons.info_outline_rounded,
                  color: iconColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    verified
                        ? 'Account verified'
                        : 'Complete verification for full access',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                if (!verified)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: context.mutedText,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsThemeTile extends StatelessWidget {
  const SettingsThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, _) {
        return SettingsMenuTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark appearance',
          subtitle: themeController.isDarkEnabled ? 'On' : 'Off',
          trailing: Switch.adaptive(
            value: themeController.isDarkEnabled,
            activeColor: EPColors.appMainLightColor,
            onChanged: (_) => themeController.toggleDarkLight(),
          ),
          onTap: () => themeController.toggleDarkLight(),
        );
      },
    );
  }
}
