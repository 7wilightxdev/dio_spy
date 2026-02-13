import 'dart:async';

import 'package:flutter/material.dart';

import '../theme.dart';

class DioSpyToast {
  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void show(BuildContext context, [String message = 'Copied']) {
    _currentEntry?.remove();
    _timer?.cancel();

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).padding.bottom + 48,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: _ToastWidget(message: message),
          ),
        ),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _timer = Timer(const Duration(milliseconds: 1500), () {
      entry.remove();
      _currentEntry = null;
    });
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.message});
  final String message;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: DioSpyColors.primary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: DioSpyColors.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          widget.message,
          style: DioSpyTypo.t16.copyWith(color: DioSpyColors.textOnPrimary),
        ),
      ),
    );
  }
}
