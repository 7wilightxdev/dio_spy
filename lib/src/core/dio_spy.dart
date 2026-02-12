import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shake_gesture/shake_gesture.dart';

import '../ui/call_list/call_list_screen.dart';
import 'dio_spy_interceptor.dart';
import 'dio_spy_storage.dart';

class DioSpy {
  DioSpy({bool showOnShake = true, int maxCalls = 1000})
      : _storage = DioSpyStorage(maxCalls: maxCalls) {
    _interceptor = DioSpyInterceptor(_storage);

    if (showOnShake) {
      _onShake = show;
      ShakeGesture.registerCallback(onShake: _onShake!);
    }
  }

  final DioSpyStorage _storage;

  late final GlobalKey<NavigatorState> _navigatorKey;
  late final DioSpyInterceptor _interceptor;
  VoidCallback? _onShake;
  bool _isInspectorOpen = false;

  /// Add this to `dio.interceptors.add(dioSpy.interceptor)`
  Interceptor get interceptor => _interceptor;

  /// Set the navigator key
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Open the inspector manually
  void show() {
    if (_isInspectorOpen) return;

    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    _isInspectorOpen = true;
    navigator
        .push(MaterialPageRoute(builder: (_) => CallListScreen(storage: _storage)))
        .then((_) => _isInspectorOpen = false);
  }

  /// Clear all logged calls
  void clear() {
    _storage.clear();
  }

  /// Dispose shake listener
  void dispose() {
    if (_onShake != null) {
      ShakeGesture.unregisterCallback(onShake: _onShake!);
    }
  }
}
