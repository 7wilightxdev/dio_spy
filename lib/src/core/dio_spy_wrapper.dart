import 'package:flutter/material.dart';

import 'dio_spy.dart';
import '../ui/call_list/call_list_screen.dart';

/// A widget that enables the DioSpy inspector overlay.
///
/// Example:
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     child = DioSpyWrapper(dioSpy: dioSpy, child: child!);
///     return myOtherBuilder(context, child);
///   },
/// )
/// ```
class DioSpyWrapper extends StatelessWidget {
  const DioSpyWrapper({
    super.key,
    required this.dioSpy,
    required this.child,
  });

  /// The [DioSpy] instance to connect to.
  final DioSpy dioSpy;

  /// The child widget (typically the app's Navigator from MaterialApp.builder).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dioSpy.inspectorVisible,
      child: child,
      builder: (context, inspectorVisible, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            _buildInspectorOverlay(context, inspectorVisible),
          ],
        );
      },
    );
  }

  Widget _buildInspectorOverlay(BuildContext context, bool inspectorVisible) {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: const Offset(0, 0),
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        child: inspectorVisible
            ? HeroControllerScope.none(
                key: const ValueKey('inspector'),
                child: Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => CallListScreen(
                      storage: dioSpy.storage,
                      onBack: dioSpy.hideInspector,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
