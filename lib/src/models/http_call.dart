import 'http_error.dart';
import 'http_request.dart';
import 'http_response.dart';

class DioSpyHttpCall {
  DioSpyHttpCall(this.id) : createdTime = DateTime.now();

  final int id;
  final DateTime createdTime;
  String method = '';
  String endpoint = '';
  String server = '';
  String uri = '';
  bool secure = false;
  bool loading = true;
  int duration = 0;

  DioSpyHttpRequest? request;
  DioSpyHttpResponse? response;
  DioSpyHttpError? error;
}
