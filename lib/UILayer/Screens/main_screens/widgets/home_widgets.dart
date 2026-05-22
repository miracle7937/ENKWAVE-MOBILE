import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeKycBanner extends StatelessWidget {
  final VoidCallback onTap;

  const HomeKycBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final warningBg = context.isDarkMode
        ? const Color(0xFF3D2E14)
        : const Color(0xFFFEF3C7);
    return Material(
      color: warningBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.verified_user_outlined,
                  color: EPColors.appWarning, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Verify your account for full access',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(Icons.chevron_right, color: context.mutedText, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

/// Organization / app logo shown top-right on the home greeting row.
class HomeOrgLogo extends StatelessWidget {
  final double height;

  const HomeOrgLogo({super.key, this.height = 44});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandingController>(
      builder: (context, branding, _) {
        final logoUrl = branding.branding?.logoUrl;
        return Container(
          height: height,
          constraints: const BoxConstraints(maxWidth: 96, minWidth: 56),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: context.cardFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
            boxShadow: context.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: EPColors.appMainColor.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: logoUrl != null && logoUrl.isNotEmpty
              ? Image.network(
                  logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    EPImages.splashScreenLogo,
                    fit: BoxFit.contain,
                  ),
                )
              : Image.asset(
                  EPImages.splashScreenLogo,
                  fit: BoxFit.contain,
                ),
        );
      },
    );
  }
}

class HomeHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final bool isMale;
  final double shrinkFactor;

  const HomeHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.isMale,
    this.shrinkFactor = 0,
  });

  String get _displayName {
    final trimmed = name.trim();
    return trimmed.isEmpty ? 'Agent' : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = shrinkFactor.clamp(0.0, 1.0);
    final greetingSize = 12.0 - (t * 1.5);
    final nameSize = 17.0 - (t * 2.5);
    final avatarSize = 40.0 - (t * 6);
    final iconSize = 22.0 - (t * 3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withValues(alpha: 0.18),
                scheme.primary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Icon(
            isMale ? Icons.person_outline_rounded : Icons.person_2_outlined,
            color: scheme.primary,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: greetingSize,
                  color: context.mutedText,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 1),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: nameSize,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.25,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        HomeOrgLogo(height: avatarSize.clamp(36, 44)),
      ],
    );
  }
}

/// Pinned home greeting — stays visible while scrolling services.
class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String greeting;
  final String name;
  final bool isMale;

  HomeHeaderDelegate({
    required this.greeting,
    required this.name,
    required this.isMale,
  });

  static const double _maxHeight = 64;
  static const double _minHeight = 50;

  @override
  double get maxExtent => _maxHeight;

  @override
  double get minExtent => _minHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final shrinkFactor = shrinkOffset / (maxExtent - minExtent);

    return Material(
      color: scheme.surface,
      elevation: overlapsContent ? 0.5 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            bottom: BorderSide(
              color: overlapsContent
                  ? context.borderColor
                  : Colors.transparent,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: HomeHeader(
              greeting: greeting,
              name: name,
              isMale: isMale,
              shrinkFactor: shrinkFactor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate oldDelegate) {
    return oldDelegate.greeting != greeting ||
        oldDelegate.name != name ||
        oldDelegate.isMale != isMale;
  }
}

class HomeServiceTile extends StatelessWidget {
  final IntroModel model;

  const HomeServiceTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: context.cardFill,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: context.borderColor.withValues(alpha: 0.85),
            ),
            boxShadow: context.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: EPColors.appMainColor.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minSide =
                  constraints.maxHeight < constraints.maxWidth
                      ? constraints.maxHeight
                      : constraints.maxWidth;
              final ultraCompact = minSide < 80;
              final compact = !ultraCompact && minSide < 112;
              final pad = ultraCompact ? 4.0 : 8.0;
              final iconSize = ultraCompact ? 22.0 : (compact ? 28.0 : 36.0);
              final iconPad = ultraCompact ? 3.0 : 6.0;
              final gap = ultraCompact ? 2.0 : (compact ? 4.0 : 8.0);
              final titleSize = ultraCompact ? 8.0 : (compact ? 9.0 : 11.0);

              return Padding(
                padding: EdgeInsets.all(pad),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (model.newFeature == true && !compact && !ultraCompact)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: EPColors.appMainLightColor
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEW',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 8,
                                ),
                          ),
                        ),
                      ),
                    Container(
                      width: iconSize,
                      height: iconSize,
                      padding: EdgeInsets.all(iconPad),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(model.image, fit: BoxFit.contain),
                    ),
                    SizedBox(height: gap),
                    Text(
                      model.title,
                      textAlign: TextAlign.center,
                      maxLines: ultraCompact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                            fontSize: titleSize,
                            height: 1.1,
                          ),
                    ),
                    if (!compact && !ultraCompact) ...[
                      const SizedBox(height: 2),
                      Text(
                        model.subTitle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.mutedText,
                              fontSize: 9,
                              height: 1.1,
                            ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BalanceActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const BalanceActionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
