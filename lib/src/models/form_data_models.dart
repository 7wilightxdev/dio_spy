class DioSpyFormDataFile {
  DioSpyFormDataFile({
    required this.fileName,
    required this.contentType,
    required this.length,
  });

  final String fileName;
  final String contentType;
  final int length;
}

class DioSpyFormDataField {
  DioSpyFormDataField({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;
}
