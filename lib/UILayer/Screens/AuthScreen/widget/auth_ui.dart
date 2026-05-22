import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/change_organization_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/whitelabel/org_select_screen.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Purple gradient hero used on sign-in and related auth flows.
class AuthHeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final bool extendToTop;

  const AuthHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.extendToTop = true,
  });

  static SystemUiOverlayStyle overlayStyleFor(BuildContext context) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Theme.of(context).colorScheme.surface,
      systemNavigationBarIconBrightness:
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = extendToTop ? MediaQuery.paddingOf(context).top : 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyleFor(context),
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EPColors.appMainDark,
            EPColors.appMainColor,
            EPColors.appMainLightColor,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 8),
              ],
              const AuthOrgLogo(height: 44),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
    );
  }
}

/// Organization logo for auth hero — left-aligned, uses whitelabel [logoUrl].
class AuthOrgLogo extends StatelessWidget {
  final double height;

  const AuthOrgLogo({super.key, this.height = 44});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandingController>(
      builder: (context, branding, _) {
        final logoUrl = branding.branding?.logoUrl;
        final hasRemoteLogo = logoUrl != null && logoUrl.trim().isNotEmpty;

        return Container(
          height: height,
          constraints: BoxConstraints(
            maxWidth: height * 2.8,
            minWidth: height,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: hasRemoteLogo
              ? Image.network(
                  logoUrl.trim(),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _fallbackAsset(),
                )
              : _fallbackAsset(),
        );
      },
    );
  }

  Widget _fallbackAsset() {
    return Image.asset(
      EPImages.splashScreenLogo,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(
        EPImages.testIcon,
        fit: BoxFit.contain,
      ),
    );
  }
}

class AuthFormCard extends StatelessWidget {
  final List<Widget> children;

  const AuthFormCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
      decoration: BoxDecoration(
        color: context.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  final String label;

  const AuthFieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  final String hintText;
  final String? label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? prefixIcon;

  const AuthTextField({
    super.key,
    required this.hintText,
    this.label,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _hidden;

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fieldFill = context.inputFill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) AuthFieldLabel(widget.label!),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          obscureText: _hidden,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
                fontSize: 14,
              ),
          cursorColor: EPColors.appMainColor,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: context.mutedText,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            filled: true,
            fillColor: fieldFill,
            prefixIcon: widget.prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: context.mutedText,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: EPColors.appMainColor,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool loading;

  const AuthPrimaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: EPColors.appMainColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: EPColors.appMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: loading
            ? const LoaderIndicator.small()
            : Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

class AuthOutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;

  const AuthOutlineButton({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon ?? Icons.swap_horiz_rounded,
          size: 18,
          color: EPColors.appMainColor,
        ),
        label: Text(
          title,
          style: TextStyle(
            color: EPColors.appMainColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: EPColors.appMainColor.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: context.isDarkMode
              ? EPColors.appMainColor.withValues(alpha: 0.08)
              : EPColors.appAccent.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class AuthDividerLabel extends StatelessWidget {
  final String label;

  const AuthDividerLabel({super.key, this.label = 'or'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.borderColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.mutedText,
              ),
            ),
          ),
          Expanded(child: Divider(color: context.borderColor)),
        ],
      ),
    );
  }
}

class AuthBiometricButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const AuthBiometricButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardFill,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.borderColor),
          ),
          alignment: Alignment.center,
          child: SizedBox(width: 28, height: 28, child: icon),
        ),
      ),
    );
  }
}

class AuthLinkRow extends StatelessWidget {
  final String prefix;
  final String action;
  final VoidCallback? onAction;

  const AuthLinkRow({
    super.key,
    required this.prefix,
    required this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: TextStyle(
            fontSize: 14,
            color: context.mutedText,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: TextStyle(
              fontSize: 14,
              color: EPColors.appMainColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows the active organization during sign-in / registration.
class OrganizationContextBanner extends StatelessWidget {
  const OrganizationContextBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandingController>(
      builder: (context, branding, _) {
        if (!branding.hasOrganization) {
          return Material(
            color: EPColors.appWarning.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              dense: true,
              leading: Icon(Icons.business_outlined, color: EPColors.appWarning),
              title: const Text(
                'Select organization',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              subtitle: const Text(
                'Required before you register or sign in.',
                style: TextStyle(fontSize: 11),
              ),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrgSelectScreen()),
                  );
                },
                child: const Text('Choose'),
              ),
            ),
          );
        }

        return Material(
          color: EPColors.appMainColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            dense: true,
            leading: Icon(Icons.apartment_rounded, color: EPColors.appMainColor),
            title: Text(
              branding.branding?.name ?? 'Organization',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            subtitle: Text(
              'Code: ${branding.orgSlug ?? '—'}',
              style: TextStyle(fontSize: 11, color: context.mutedText),
            ),
            trailing: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangeOrganizationScreen(),
                  ),
                );
              },
              child: const Text('Change'),
            ),
          ),
        );
      },
    );
  }
}
