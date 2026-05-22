import 'dart:math' as math;

import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

/// Compact spinner for buttons and inline use.
class LoaderIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;

  const LoaderIndicator({
    super.key,
    this.size = 28,
    this.strokeWidth = 3,
    this.color,
    this.trackColor,
  });

  const LoaderIndicator.small({super.key})
      : size = 22,
        strokeWidth = 2.5,
        color = Colors.white,
        trackColor = Colors.white24;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: _GradientSpinner(
        size: size,
        strokeWidth: strokeWidth,
        color: color ?? EPColors.appMainColor,
        trackColor: trackColor ??
            EPColors.appMainColor.withValues(alpha: 0.15),
      ),
    );
  }
}

/// Full-screen or centered loading state with optional message.
class LoaderWidget extends StatelessWidget {
  final String? message;
  final bool showCard;

  const LoaderWidget({
    super.key,
    this.message,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoaderIndicator(size: 48, strokeWidth: 3.5),
        const SizedBox(height: 20),
        Text(
          message ?? 'Loading',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.mutedText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
        ),
        const SizedBox(height: 12),
        _LoadingDots(color: EPColors.appMainColor),
      ],
    );

    if (!showCard) {
      return Center(child: content);
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          decoration: BoxDecoration(
            color: context.cardFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.borderColor),
            boxShadow: [
              BoxShadow(
                color: (context.isDarkMode
                        ? EPColors.appMainLightColor
                        : EPColors.appMainColor)
                    .withValues(alpha: context.isDarkMode ? 0.2 : 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  final Color color;

  const _LoadingDots({required this.color});

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final t = (_controller.value + delay) % 1.0;
            final scale = 0.5 + 0.5 * math.sin(t * math.pi);
            return Container(
              margin: EdgeInsets.only(left: index == 0 ? 0 : 6),
              width: 7,
              height: 7,
              transform: Matrix4.diagonal3Values(scale, scale, 1),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.4 + scale * 0.6),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

class _GradientSpinner extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  const _GradientSpinner({
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  @override
  State<_GradientSpinner> createState() => _GradientSpinnerState();
}

class _GradientSpinnerState extends State<_GradientSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _SpinnerPainter(
            rotation: _controller.value * 2 * math.pi,
            strokeWidth: widget.strokeWidth,
            color: widget.color,
            trackColor: widget.trackColor,
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double rotation;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  _SpinnerPainter({
    required this.rotation,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = math.pi * 1.35;

    final arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: rotation,
        endAngle: rotation + sweep,
        colors: [
          color.withValues(alpha: 0.05),
          color,
          EPColors.appMainLightColor,
        ],
        stops: const [0.0, 0.55, 1.0],
        transform: GradientRotation(rotation),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      rotation,
      sweep,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
