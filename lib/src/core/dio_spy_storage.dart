import 'package:flutter/foundation.dart';

import '../models/http_call.dart';
import '../models/http_error.dart';
import '../models/http_response.dart';

class DioSpyStorage {
  DioSpyStorage({this.maxCalls = 1000});

  final int maxCalls;
  final _calls = ValueNotifier<List<DioSpyHttpCall>>([]);

  ValueListenable<List<DioSpyHttpCall>> get calls => _calls;

  void addCall(DioSpyHttpCall call) {
    final list = List<DioSpyHttpCall>.from(_calls.value);
    list.insert(0, call);
    if (list.length > maxCalls) {
      list.removeLast();
    }
    _calls.value = list;
  }

  void addResponse(int id, DioSpyHttpResponse response) {
    final list = List<DioSpyHttpCall>.from(_calls.value);
    final index = list.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final call = list[index];
    call.response = response;
    call.loading = false;
    if (call.request != null) {
      call.duration =
          response.time.millisecondsSinceEpoch - call.request!.time.millisecondsSinceEpoch;
    }
    _calls.value = list;
  }

  void addError(int id, DioSpyHttpError error) {
    final list = List<DioSpyHttpCall>.from(_calls.value);
    final index = list.indexWhere((c) => c.id == id);
    if (index == -1) return;

    list[index].error = error;
    _calls.value = list;
  }

  void clear() {
    _calls.value = [];
  }
}
