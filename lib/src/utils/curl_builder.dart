import '../models/http_call.dart';

class CurlBuilder {
  static String build(DioSpyHttpCall call) {
    final request = call.request;
    if (request == null) return '';

    final parts = <String>[];
    parts.add("curl -X ${call.method}");
    parts.add("'${call.uri}'");

    // Headers
    request.headers.forEach((key, value) {
      final escaped = value.replaceAll("'", "\\'");
      parts.add("-H '$key: $escaped'");
    });

    // Cookies
    if (request.cookies.isNotEmpty) {
      final cookieStr = request.cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
      parts.add("--cookie '$cookieStr'");
    }

    // Body
    if (request.body != null && request.body.toString().isNotEmpty) {
      final bodyStr = request.body.toString().replaceAll("'", "\\'");
      parts.add("-d '$bodyStr'");
    }

    return parts.join(' \\\n  ');
  }

  static String buildAll(List<DioSpyHttpCall> calls) {
    return calls.map(build).where((s) => s.isNotEmpty).join('\n\n');
  }
}
