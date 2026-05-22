import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:flutter/material.dart';

class PinDots extends StatelessWidget {
  final int length;
  final int filled;
  final Color activeColor;
  final Color emptyColor;
  final bool useBoxes;

  const PinDots({
    super.key,
    required this.length,
    required this.filled,
    required this.activeColor,
    required this.emptyColor,
    this.useBoxes = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isFilled = i < filled;
        if (useBoxes) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 48,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isFilled
                  ? activeColor.withValues(alpha: 0.12)
                  : emptyColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFilled ? activeColor : emptyColor,
                width: isFilled ? 2 : 1,
              ),
            ),
            child: isFilled
                ? Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          );
        }
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: isFilled ? 14 : 12,
          height: isFilled ? 14 : 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? activeColor : emptyColor,
            border: Border.all(
              color: isFilled ? activeColor : emptyColor.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}

class PinKeypad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final bool compact;

  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    final scheme = Theme.of(context).colorScheme;
    final spacing = compact ? 8.0 : 12.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: compact ? 1.5 : 1.35,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        if (key.isEmpty) return const SizedBox.shrink();
        final isBack = key == '⌫';
        return Material(
          color: context.cardFill,
          borderRadius: BorderRadius.circular(compact ? 12 : 16),
          child: InkWell(
            onTap: isBack ? onBackspace : () => onDigit(key),
            borderRadius: BorderRadius.circular(compact ? 12 : 16),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(compact ? 12 : 16),
                border: Border.all(color: context.borderColor),
              ),
              child: Center(
                child: isBack
                    ? Icon(
                        Icons.backspace_outlined,
                        color: scheme.onSurface,
                        size: compact ? 20 : 22,
                      )
                    : Text(
                        key,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: compact ? 20 : null,
                              color: scheme.onSurface,
                            ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
