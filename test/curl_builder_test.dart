import 'package:dio_spy/src/models/http_call.dart';
import 'package:dio_spy/src/models/http_request.dart';
import 'package:dio_spy/src/utils/curl_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurlBuilder', () {
    test('should return empty string if request is null', () {
      final call = DioSpyHttpCall(1);
      call.method = 'GET';
      call.uri = 'https://example.com/api/users';

      expect(CurlBuilder.build(call), '');
    });

    test('should build basic GET request', () {
      final call = DioSpyHttpCall(1);
      call.method = 'GET';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();

      final curl = CurlBuilder.build(call);

      expect(curl, contains("curl -X GET"));
      expect(curl, contains("'https://example.com/api/users'"));
    });

    test('should build POST request', () {
      final call = DioSpyHttpCall(1);
      call.method = 'POST';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();

      final curl = CurlBuilder.build(call);

      expect(curl, contains("curl -X POST"));
    });

    test('should include headers', () {
      final call = DioSpyHttpCall(1);
      call.method = 'GET';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer token123',
      };

      final curl = CurlBuilder.build(call);

      expect(curl, contains("-H 'Content-Type: application/json'"));
      expect(curl, contains("-H 'Authorization: Bearer token123'"));
    });

    test('should escape single quotes in header values', () {
      final call = DioSpyHttpCall(1);
      call.method = 'GET';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.headers = {
        'X-Custom': "value with 'quotes'",
      };

      final curl = CurlBuilder.build(call);

      expect(curl, contains(r"value with \'quotes\'"));
    });

    test('should include cookies', () {
      final call = DioSpyHttpCall(1);
      call.method = 'GET';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.cookies = {
        'session': 'abc123',
        'user_id': '456',
      };

      final curl = CurlBuilder.build(call);

      expect(curl, contains("--cookie"));
      expect(curl, contains('session=abc123'));
      expect(curl, contains('user_id=456'));
    });

    test('should include request body', () {
      final call = DioSpyHttpCall(1);
      call.method = 'POST';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.body = '{"name":"John","age":30}';

      final curl = CurlBuilder.build(call);

      expect(curl, contains("-d '{\"name\":\"John\",\"age\":30}'"));
    });

    test('should escape single quotes in body', () {
      final call = DioSpyHttpCall(1);
      call.method = 'POST';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.body = "text with 'quotes'";

      final curl = CurlBuilder.build(call);

      expect(curl, contains(r"-d 'text with \'quotes\''"));
    });

    test('should not include empty body', () {
      final call = DioSpyHttpCall(1);
      call.method = 'POST';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.body = '';

      final curl = CurlBuilder.build(call);

      expect(curl, isNot(contains("-d")));
    });

    test('should format with line breaks', () {
      final call = DioSpyHttpCall(1);
      call.method = 'POST';
      call.uri = 'https://example.com/api/users';
      call.request = DioSpyHttpRequest();
      call.request!.headers = {
        'Content-Type': 'application/json',
      };
      call.request!.body = '{"name":"John"}';

      final curl = CurlBuilder.build(call);

      expect(curl, contains('\\\n'));
    });

    test('should build cURL for multiple calls', () {
      final call1 = DioSpyHttpCall(1);
      call1.method = 'GET';
      call1.uri = 'https://example.com/api/users';
      call1.request = DioSpyHttpRequest();

      final call2 = DioSpyHttpCall(2);
      call2.method = 'POST';
      call2.uri = 'https://example.com/api/posts';
      call2.request = DioSpyHttpRequest();
      call2.request!.body = '{"title":"Test"}';

      final curl = CurlBuilder.buildAll([call1, call2]);

      expect(curl, contains('curl -X GET'));
      expect(curl, contains('curl -X POST'));
      expect(curl, contains('\n\n')); // Separator between calls
    });

    test('should skip calls without request in buildAll', () {
      final call1 = DioSpyHttpCall(1);
      call1.method = 'GET';
      call1.uri = 'https://example.com/api/users';
      // No request set

      final call2 = DioSpyHttpCall(2);
      call2.method = 'POST';
      call2.uri = 'https://example.com/api/posts';
      call2.request = DioSpyHttpRequest();

      final curl = CurlBuilder.buildAll([call1, call2]);

      expect(curl, isNot(contains('GET')));
      expect(curl, contains('POST'));
    });

    test('should build complete cURL with all features', () {
      final call = DioSpyHttpCall(1);
      call.method = 'POST';
      call.uri = 'https://api.example.com/v1/users?page=1&limit=10';
      call.request = DioSpyHttpRequest();
      call.request!.headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer token123',
        'X-API-Key': 'key456',
      };
      call.request!.cookies = {
        'session': 'abc123',
        'preferences': 'dark_mode',
      };
      call.request!.body = '{"name":"John Doe","email":"john@example.com"}';

      final curl = CurlBuilder.build(call);

      // Verify all components are present
      expect(curl, contains('curl -X POST'));
      expect(curl, contains("'https://api.example.com/v1/users?page=1&limit=10'"));
      expect(curl, contains("-H 'Content-Type: application/json'"));
      expect(curl, contains("-H 'Authorization: Bearer token123'"));
      expect(curl, contains("-H 'X-API-Key: key456'"));
      expect(curl, contains('--cookie'));
      expect(curl, contains('session=abc123'));
      expect(curl, contains('preferences=dark_mode'));
      expect(curl, contains('-d'));
      expect(curl, contains('John Doe'));
    });
  });
}
