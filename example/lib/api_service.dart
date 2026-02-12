import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'https://fakerestapi.azurewebsites.net/api/v1';

  final Dio dio;

  ApiService(this.dio);

  // ==================== Activities ====================

  Future<List<dynamic>> getActivities() async {
    final response = await dio.get('$baseUrl/Activities');
    return response.data;
  }

  Future<dynamic> getActivity(int id) async {
    final response = await dio.get('$baseUrl/Activities/$id');
    return response.data;
  }

  Future<dynamic> createActivity({
    required int id,
    required String title,
    required DateTime dueDate,
    required bool completed,
  }) async {
    final response = await dio.post(
      '$baseUrl/Activities',
      data: {
        'id': id,
        'title': title,
        'dueDate': dueDate.toIso8601String(),
        'completed': completed,
      },
    );
    return response.data;
  }

  Future<dynamic> updateActivity({
    required int id,
    required String title,
    required DateTime dueDate,
    required bool completed,
  }) async {
    final response = await dio.put(
      '$baseUrl/Activities/$id',
      data: {
        'id': id,
        'title': title,
        'dueDate': dueDate.toIso8601String(),
        'completed': completed,
      },
    );
    return response.data;
  }

  Future<void> deleteActivity(int id) async {
    await dio.delete('$baseUrl/Activities/$id');
  }

  // ==================== Books ====================

  Future<List<dynamic>> getBooks() async {
    final response = await dio.get('$baseUrl/Books');
    return response.data;
  }

  Future<dynamic> getBook(int id) async {
    final response = await dio.get('$baseUrl/Books/$id');
    return response.data;
  }

  Future<dynamic> createBook({
    required int id,
    required String title,
    required String description,
    required int pageCount,
    required String excerpt,
    required DateTime publishDate,
  }) async {
    final response = await dio.post(
      '$baseUrl/Books',
      data: {
        'id': id,
        'title': title,
        'description': description,
        'pageCount': pageCount,
        'excerpt': excerpt,
        'publishDate': publishDate.toIso8601String(),
      },
    );
    return response.data;
  }

  Future<dynamic> updateBook({
    required int id,
    required String title,
    required String description,
    required int pageCount,
    required String excerpt,
    required DateTime publishDate,
  }) async {
    final response = await dio.put(
      '$baseUrl/Books/$id',
      data: {
        'id': id,
        'title': title,
        'description': description,
        'pageCount': pageCount,
        'excerpt': excerpt,
        'publishDate': publishDate.toIso8601String(),
      },
    );
    return response.data;
  }

  Future<void> deleteBook(int id) async {
    await dio.delete('$baseUrl/Books/$id');
  }

  // ==================== Users ====================

  Future<List<dynamic>> getUsers() async {
    final response = await dio.get('$baseUrl/Users');
    return response.data;
  }

  Future<dynamic> getUser(int id) async {
    final response = await dio.get('$baseUrl/Users/$id');
    return response.data;
  }

  Future<dynamic> createUser({
    required int id,
    required String userName,
    required String password,
  }) async {
    final response = await dio.post(
      '$baseUrl/Users',
      data: {
        'id': id,
        'userName': userName,
        'password': password,
      },
    );
    return response.data;
  }

  Future<void> deleteUser(int id) async {
    await dio.delete('$baseUrl/Users/$id');
  }

  // ==================== Authors ====================

  Future<List<dynamic>> getAuthors() async {
    final response = await dio.get('$baseUrl/Authors');
    return response.data;
  }

  Future<dynamic> getAuthor(int id) async {
    final response = await dio.get('$baseUrl/Authors/$id');
    return response.data;
  }

  Future<List<dynamic>> getAuthorsByBook(int bookId) async {
    final response = await dio.get('$baseUrl/Authors/authors/books/$bookId');
    return response.data;
  }

  // ==================== Test Invalid Endpoint (for error demo) ====================

  Future<dynamic> getInvalidEndpoint() async {
    final response = await dio.get('$baseUrl/InvalidEndpoint');
    return response.data;
  }
}
