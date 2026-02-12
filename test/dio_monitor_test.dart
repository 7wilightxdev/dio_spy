import 'package:dio_spy/src/core/dio_spy_storage.dart';
import 'package:dio_spy/src/models/http_call.dart';
import 'package:dio_spy/src/models/http_error.dart';
import 'package:dio_spy/src/models/http_request.dart';
import 'package:dio_spy/src/models/http_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioSpyStorage', () {
    late DioSpyStorage storage;

    setUp(() {
      storage = DioSpyStorage(maxCalls: 3);
    });

    test('should initialize with empty list', () {
      expect(storage.calls.value, isEmpty);
    });

    test('should add call to storage', () {
      final call = DioSpyHttpCall(1);
      storage.addCall(call);

      expect(storage.calls.value.length, 1);
      expect(storage.calls.value.first.id, 1);
    });

    test('should add new calls at index 0 (newest first)', () {
      final call1 = DioSpyHttpCall(1);
      final call2 = DioSpyHttpCall(2);
      final call3 = DioSpyHttpCall(3);

      storage.addCall(call1);
      storage.addCall(call2);
      storage.addCall(call3);

      expect(storage.calls.value[0].id, 3);
      expect(storage.calls.value[1].id, 2);
      expect(storage.calls.value[2].id, 1);
    });

    test('should maintain max calls limit (circular buffer)', () {
      final call1 = DioSpyHttpCall(1);
      final call2 = DioSpyHttpCall(2);
      final call3 = DioSpyHttpCall(3);
      final call4 = DioSpyHttpCall(4);

      storage.addCall(call1);
      storage.addCall(call2);
      storage.addCall(call3);
      storage.addCall(call4); // Should remove call1

      expect(storage.calls.value.length, 3);
      expect(storage.calls.value.any((c) => c.id == 1), false);
      expect(storage.calls.value[0].id, 4);
      expect(storage.calls.value[1].id, 3);
      expect(storage.calls.value[2].id, 2);
    });

    test('should add response to existing call', () {
      final call = DioSpyHttpCall(1);
      storage.addCall(call);

      final response = DioSpyHttpResponse();
      response.status = 200;
      response.body = 'Success';

      storage.addResponse(1, response);

      expect(storage.calls.value.first.response?.status, 200);
      expect(storage.calls.value.first.response?.body, 'Success');
      expect(storage.calls.value.first.loading, false);
    });

    test('should calculate duration when adding response', () async {
      final call = DioSpyHttpCall(1);
      call.request = DioSpyHttpRequest();
      call.request!.time = DateTime.now();
      storage.addCall(call);

      // Wait a bit to simulate request duration
      await Future.delayed(const Duration(milliseconds: 10));

      final response = DioSpyHttpResponse();
      response.time = DateTime.now();
      storage.addResponse(1, response);

      expect(storage.calls.value.first.duration, greaterThan(0));
    });

    test('should not add response if call not found', () {
      final response = DioSpyHttpResponse();
      response.status = 200;

      storage.addResponse(999, response); // Non-existent ID

      expect(storage.calls.value, isEmpty);
    });

    test('should add error to existing call', () {
      final call = DioSpyHttpCall(1);
      storage.addCall(call);

      final error = DioSpyHttpError(
        error: 'Network error',
        stackTrace: StackTrace.current,
      );

      storage.addError(1, error);

      expect(storage.calls.value.first.error?.error, 'Network error');
      expect(storage.calls.value.first.error?.stackTrace, isNotNull);
    });

    test('should clear all calls', () {
      storage.addCall(DioSpyHttpCall(1));
      storage.addCall(DioSpyHttpCall(2));
      storage.addCall(DioSpyHttpCall(3));

      expect(storage.calls.value.length, 3);

      storage.clear();

      expect(storage.calls.value, isEmpty);
    });

    test('should notify listeners when calls change', () {
      var notificationCount = 0;
      storage.calls.addListener(() {
        notificationCount++;
      });

      storage.addCall(DioSpyHttpCall(1));
      storage.addCall(DioSpyHttpCall(2));
      storage.clear();

      expect(notificationCount, 3);
    });
  });
}
