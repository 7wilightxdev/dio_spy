import 'form_data_models.dart';

class DioSpyHttpRequest {
  DateTime time = DateTime.now();
  int size = 0;
  Map<String, String> headers = {};
  dynamic body;
  String? contentType;
  Map<String, String> cookies = {};
  Map<String, dynamic> queryParameters = {};
  List<DioSpyFormDataFile>? formDataFiles;
  List<DioSpyFormDataField>? formDataFields;
}
