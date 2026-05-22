import 'dart:async';

import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/services/navigation_service.dart';
import 'package:flutter/material.dart';

/// Top-of-screen linear progress while POS terminal keys are downloading.
class PosPrepProgressOverlay {
  static _PosPrepTopBarState? _barState;
  static OverlayEntry? _entry;

  /// Navigator overlay (login uses [NavigatorState.context], which has no Overlay).
  static OverlayState? _resolveOverlay(BuildContext context) {
    final fromNav = NavigationService.navigatorKey.currentState?.overlay;
    if (fromNav != null) return fromNav;
    return Overlay.maybeOf(context, rootOverlay: true);
  }

  /// Runs [task] while showing 0→100% progress; shows "POS ready" then dismisses.
  static Future<T?> run<T>(
    BuildContext context, {
    required Future<T> Function() task,
  }) async {
    final overlay = _resolveOverlay(context);
    if (overlay == null) {
      return task();
    }
    _entry = OverlayEntry(
      builder: (ctx) => _PosPrepTopBar(
        onStateCreated: (s) => _barState = s,
      ),
    );
    overlay.insert(_entry!);
    await Future<void>.delayed(Duration.zero);
    _barState?.startProgress();

    try {
      final result = await task();
      await _barState?.showReadyAndDismiss();
      return result;
    } catch (_) {
      await _barState?.dismissQuickly();
      rethrow;
    } finally {
      _entry?.remove();
      _entry = null;
      _barState = null;
    }
  }
}

class _PosPrepTopBar extends StatefulWidget {
  const _PosPrepTopBar({required this.onStateCreated});

  final void Function(_PosPrepTopBarState state) onStateCreated;

  @override
  State<_PosPrepTopBar> createState() => _PosPrepTopBarState();
}

class _PosPrepTopBarState extends State<_PosPrepTopBar> {
  double _progress = 0;
  String _label = 'Preparing POS terminal…';
  bool _visible = true;
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onStateCreated(this);
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  void startProgress() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        if (_progress < 0.92) {
          _progress += 0.018;
        }
      });
    });
  }

  Future<void> showReadyAndDismiss() async {
    _tickTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _progress = 1;
      _label = 'POS ready';
    });
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _visible = false);
    await Future<void>.delayed(const Duration(milliseconds: 280));
  }

  Future<void> dismissQuickly() async {
    _tickTimer?.cancel();
    if (!mounted) return;
    setState(() => _visible = false);
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final percent = (_progress.clamp(0.0, 1.0) * 100).round();
    final isReady = _progress >= 1;

    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withValues(alpha: 0.25),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
              value: _progress.clamp(0.0, 1.0),
              minHeight: 4,
              color: isReady ? EPColors.appSuccess : EPColors.appMainColor,
              backgroundColor: EPColors.appMainLightColor.withValues(alpha: 0.35),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: EPColors.appMainDark.withValues(alpha: 0.94),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (isReady)
                    Icon(Icons.check_circle_rounded,
                        color: EPColors.appSuccess, size: 20)
                  else
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: EPColors.appWhiteColor,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: EPColors.appAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ],
    );
  }
}
