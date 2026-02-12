class DioSpyHttpResponse {
  int? status;
  DateTime time = DateTime.now();
  int size = 0;
  dynamic body;
  Map<String, String> headers = {};
}
