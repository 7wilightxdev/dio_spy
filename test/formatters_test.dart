import 'package:dio_spy/src/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioSpyFormatters', () {
    group('formatBytes', () {
      test('should format 0 bytes', () {
        expect(DioSpyFormatters.formatBytes(0), '0 B');
      });

      test('should format bytes less than 1 KB', () {
        expect(DioSpyFormatters.formatBytes(100), '100 B');
        expect(DioSpyFormatters.formatBytes(512), '512 B');
        expect(DioSpyFormatters.formatBytes(1023), '1023 B');
      });

      test('should format KB', () {
        expect(DioSpyFormatters.formatBytes(1024), '1.0 KB');
        expect(DioSpyFormatters.formatBytes(2048), '2.0 KB');
        expect(DioSpyFormatters.formatBytes(1536), '1.5 KB');
        expect(DioSpyFormatters.formatBytes(10240), '10.0 KB');
      });

      test('should format MB', () {
        expect(DioSpyFormatters.formatBytes(1048576), '1.0 MB');
        expect(DioSpyFormatters.formatBytes(2097152), '2.0 MB');
        expect(DioSpyFormatters.formatBytes(1572864), '1.5 MB');
      });

      test('should handle negative values', () {
        expect(DioSpyFormatters.formatBytes(-100), '0 B');
      });
    });

    group('formatDuration', () {
      test('should format milliseconds', () {
        expect(DioSpyFormatters.formatDuration(0), '0 ms');
        expect(DioSpyFormatters.formatDuration(50), '50 ms');
        expect(DioSpyFormatters.formatDuration(999), '999 ms');
      });

      test('should format seconds', () {
        expect(DioSpyFormatters.formatDuration(1000), '1.0s');
        expect(DioSpyFormatters.formatDuration(1500), '1.5s');
        expect(DioSpyFormatters.formatDuration(5000), '5.0s');
        expect(DioSpyFormatters.formatDuration(59999), '60.0s');
      });

      test('should format minutes', () {
        expect(DioSpyFormatters.formatDuration(60000), '1.0m');
        expect(DioSpyFormatters.formatDuration(90000), '1.5m');
        expect(DioSpyFormatters.formatDuration(120000), '2.0m');
      });

      test('should handle negative values', () {
        expect(DioSpyFormatters.formatDuration(-100), '0 ms');
      });
    });

    group('formatTime', () {
      test('should format time with leading zeros', () {
        final time = DateTime(2024, 1, 1, 9, 5, 3, 7);
        expect(DioSpyFormatters.formatTime(time), '09:05:03.007');
      });

      test('should format time without leading zeros needed', () {
        final time = DateTime(2024, 1, 1, 15, 30, 45, 123);
        expect(DioSpyFormatters.formatTime(time), '15:30:45.123');
      });

      test('should format midnight', () {
        final time = DateTime(2024, 1, 1, 0, 0, 0, 0);
        expect(DioSpyFormatters.formatTime(time), '00:00:00.000');
      });
    });

    group('formatDateTime', () {
      test('should format full date time', () {
        final dateTime = DateTime(2024, 1, 15, 9, 30, 45, 123);
        expect(
          DioSpyFormatters.formatDateTime(dateTime),
          '2024-01-15 09:30:45.123',
        );
      });

      test('should format with single digit month and day', () {
        final dateTime = DateTime(2024, 3, 5, 14, 22, 10, 50);
        expect(
          DioSpyFormatters.formatDateTime(dateTime),
          '2024-03-05 14:22:10.050',
        );
      });
    });

    group('formatBody', () {
      test('should return empty string for null', () {
        expect(DioSpyFormatters.formatBody(null), '');
      });

      test('should format Map as indented JSON', () {
        final body = {'name': 'John', 'age': 30};
        final formatted = DioSpyFormatters.formatBody(body);

        expect(formatted, contains('"name": "John"'));
        expect(formatted, contains('"age": 30'));
        expect(formatted, contains('\n'));
      });

      test('should format List as indented JSON', () {
        final body = [1, 2, 3];
        final formatted = DioSpyFormatters.formatBody(body);

        expect(formatted, contains('1'));
        expect(formatted, contains('2'));
        expect(formatted, contains('3'));
        expect(formatted, contains('\n'));
      });

      test('should parse and format JSON string', () {
        final body = '{"name":"John","age":30}';
        final formatted = DioSpyFormatters.formatBody(body);

        expect(formatted, contains('"name": "John"'));
        expect(formatted, contains('"age": 30'));
        expect(formatted, contains('\n'));
      });

      test('should return plain string if not valid JSON', () {
        final body = 'plain text content';
        final formatted = DioSpyFormatters.formatBody(body);

        expect(formatted, 'plain text content');
      });

      test('should convert other types to string', () {
        expect(DioSpyFormatters.formatBody(123), '123');
        expect(DioSpyFormatters.formatBody(true), 'true');
      });
    });

    group('formatStatusCode', () {
      test('should format valid status codes', () {
        expect(DioSpyFormatters.formatStatusCode(200), '200');
        expect(DioSpyFormatters.formatStatusCode(404), '404');
        expect(DioSpyFormatters.formatStatusCode(500), '500');
      });

      test('should return "Error" for null status', () {
        expect(DioSpyFormatters.formatStatusCode(null), 'Error');
      });

      test('should return "Error" for -1 status', () {
        expect(DioSpyFormatters.formatStatusCode(-1), 'Error');
      });
    });
  });
}
