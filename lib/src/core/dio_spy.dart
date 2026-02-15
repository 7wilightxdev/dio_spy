import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shake_gesture/shake_gesture.dart';

import '../ui/call_list/call_list_screen.dart';
import 'dio_spy_interceptor.dart';
import 'dio_spy_storage.dart';

/// HTTP inspector for Dio. Captures requests/responses and shows a debug UI.
///
/// ```dart
/// final dioSpy = DioSpy();
/// dio.interceptors.add(dioSpy.interceptor);
/// ```
/// Then set the navigatorKey to the [DioSpy] instance.
/// ```dart
/// final navigatorKey = GlobalKey<NavigatorState>();
/// DioSpy.setNavigatorKey(navigatorKey);
/// MaterialApp(
///   navigatorKey: navigatorKey,
///   home: MyHomePage(),
/// )
/// ```
///
/// If you want to use the inspector without a navigatorKey,
/// you can use the [DioSpyWrapper] widget.
/// ```dart
/// MaterialApp(
///   builder: (context, child) => DioSpyWrapper(dioSpy: dioSpy, child: child!),
///   home: MyHomePage(),
/// )
/// ```
///
class DioSpy {
  DioSpy({bool showOnShake = true, int maxCalls = 1000}) {
    _storage = DioSpyStorage(maxCalls: maxCalls);
    _interceptor = DioSpyInterceptor(_storage);

    if (showOnShake) {
      _onShake = showInspector;
      ShakeGesture.registerCallback(onShake: _onShake!);
    }
  }

  late final DioSpyStorage _storage;
  late final DioSpyInterceptor _interceptor;
  final ValueNotifier<bool> _inspectorVisible = ValueNotifier(false);

  GlobalKey<NavigatorState>? _navigatorKey;
  VoidCallback? _navigatorKeyListener;
  VoidCallback? _onShake;

  /// Storage of captured HTTP calls.
  DioSpyStorage get storage => _storage;

  /// Interceptor to add to your [Dio] instance.
  Interceptor get interceptor => _interceptor;

  /// Whether the inspector is currently visible.
  ValueListenable<bool> get inspectorVisible => _inspectorVisible;

  /// Pushes the inspector as a route on this navigator.
  /// See [DioSpyWrapper] for an alternative approach.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;

    if (_navigatorKeyListener != null) {
      _inspectorVisible.removeListener(_navigatorKeyListener!);
    }

    _navigatorKeyListener = () {
      if (_inspectorVisible.value) {
        final navigator = _navigatorKey?.currentState;
        if (navigator == null) {
          _inspectorVisible.value = false;
          return;
        }
        navigator
            .push(MaterialPageRoute(builder: (_) => CallListScreen(storage: _storage)))
            .then((_) => _inspectorVisible.value = false);
      }
    };
    _inspectorVisible.addListener(_navigatorKeyListener!);
  }

  /// Opens the inspector.
  void showInspector() {
    _inspectorVisible.value = true;
  }

  /// Closes the inspector.
  void hideInspector() {
    _inspectorVisible.value = false;
  }

  /// Releases resources. Call when no longer needed.
  void dispose() {
    if (_onShake != null) {
      ShakeGesture.unregisterCallback(onShake: _onShake!);
    }
    if (_navigatorKeyListener != null) {
      _inspectorVisible.removeListener(_navigatorKeyListener!);
      _navigatorKeyListener = null;
    }
    _inspectorVisible.dispose();
  }
}
