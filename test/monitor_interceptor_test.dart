import 'package:dio/dio.dart';
import 'package:dio_spy/src/core/dio_spy_interceptor.dart';
import 'package:dio_spy/src/core/dio_spy_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioSpyInterceptor', () {
    late DioSpyStorage storage;
    late DioSpyInterceptor interceptor;

    setUp(() {
      storage = DioSpyStorage();
      interceptor = DioSpyInterceptor(storage);
    });

    group('onRequest', () {
      test('should capture basic request information', () {
        final options = RequestOptions(
          path: '/api/users',
          method: 'GET',
          baseUrl: 'https://example.com',
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        expect(storage.calls.value.length, 1);
        final call = storage.calls.value.first;
        expect(call.method, 'GET');
        expect(call.endpoint, '/api/users');
        expect(call.server, 'example.com');
        expect(call.uri, 'https://example.com/api/users');
        expect(call.secure, true);
      });

      test('should detect non-secure connection', () {
        final options = RequestOptions(
          path: '/api/data',
          method: 'GET',
          baseUrl: 'http://example.com',
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final call = storage.calls.value.first;
        expect(call.secure, false);
      });

      test('should parse request headers', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer token123',
          },
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.headers['Content-Type'], 'application/json');
        expect(request?.headers['Authorization'], 'Bearer token123');
      });

      test('should parse query parameters from URI', () {
        final options = RequestOptions(
          path: '/api/users?page=1&limit=10',
          baseUrl: 'https://example.com',
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.queryParameters['page'], '1');
        expect(request?.queryParameters['limit'], '10');
      });

      test('should parse cookies from headers', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
          headers: {
            'Cookie': 'session=abc123; user_id=456',
          },
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.cookies['session'], 'abc123');
        expect(request?.cookies['user_id'], '456');
      });

      test('should parse JSON body (Map)', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
          data: {'name': 'John', 'age': 30},
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.body, isA<Map>());
        expect(request?.body['name'], 'John');
        expect(request?.body['age'], 30);
        expect(request?.size, greaterThan(0));
      });

      test('should parse JSON body (List)', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
          data: [1, 2, 3],
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.body, isA<List>());
        expect(request?.body, [1, 2, 3]);
        expect(request?.size, greaterThan(0));
      });

      test('should parse String body', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
          data: 'plain text data',
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.body, 'plain text data');
        expect(request?.size, greaterThan(0));
      });

      test('should handle FormData', () {
        final formData = FormData.fromMap({
          'field1': 'value1',
          'field2': 'value2',
          'file': MultipartFile.fromString('file content', filename: 'test.txt'),
        });

        final options = RequestOptions(
          path: '/api/upload',
          baseUrl: 'https://example.com',
          data: formData,
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.body, 'Form data');
        expect(request?.formDataFields?.length, 2);
        expect(request?.formDataFiles?.length, 1);
        expect(request?.formDataFields?[0].name, 'field1');
        expect(request?.formDataFields?[0].value, 'value1');
        expect(request?.formDataFiles?[0].fileName, 'test.txt');
      });

      test('should handle null body', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
          data: null,
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        expect(request?.body, '');
        expect(request?.size, 0);
      });

      test('should handle binary data', () {
        final options = RequestOptions(
          path: '/api/upload',
          baseUrl: 'https://example.com',
          data: [1, 2, 3, 4, 5],
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final request = storage.calls.value.first.request;
        // List<int> is treated as JSON array due to type check order
        expect(request?.body, [1, 2, 3, 4, 5]);
        expect(request?.size, greaterThan(0));
      });
    });

    group('onResponse', () {
      test('should capture response with status code', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
        );

        // First add the request
        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        // Then add the response
        final response = Response(
          requestOptions: options,
          statusCode: 200,
          data: {'message': 'success'},
        );

        interceptor.onResponse(
          response,
          ResponseInterceptorHandler(),
        );

        final call = storage.calls.value.first;
        expect(call.response?.status, 200);
        expect(call.response?.body, {'message': 'success'});
        expect(call.loading, false);
      });

      test('should parse response headers', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final response = Response(
          requestOptions: options,
          statusCode: 200,
          headers: Headers.fromMap({
            'content-type': ['application/json'],
            'x-custom-header': ['custom-value'],
          }),
        );

        interceptor.onResponse(
          response,
          ResponseInterceptorHandler(),
        );

        final responseData = storage.calls.value.first.response;
        expect(responseData?.headers['content-type'], 'application/json');
        expect(responseData?.headers['x-custom-header'], 'custom-value');
      });

      test('should calculate response body size', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://example.com',
        );

        interceptor.onRequest(
          options,
          RequestInterceptorHandler(),
        );

        final response = Response(
          requestOptions: options,
          statusCode: 200,
          data: 'Response body content',
        );

        interceptor.onResponse(
          response,
          ResponseInterceptorHandler(),
        );

        final responseData = storage.calls.value.first.response;
        expect(responseData?.size, greaterThan(0));
      });
    });

    // Note: onError tests are omitted as they require integration testing with Dio's
    // error handling mechanism. The storage update logic is covered by the storage tests.
  });
}
