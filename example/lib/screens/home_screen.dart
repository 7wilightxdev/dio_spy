import 'package:flutter/material.dart';
import '../api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _result = 'Tap any button to make an API call';
  bool _loading = false;

  Future<void> _executeRequest(
    Future<dynamic> Function() request,
    String label,
  ) async {
    setState(() {
      _loading = true;
      _result = 'Loading $label...';
    });

    try {
      final response = await request();
      setState(() {
        _result = 'Success: $label\n\n${_formatResponse(response)}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $label\n\n$e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _formatResponse(dynamic response) {
    if (response is List) {
      return 'Received ${response.length} items\n'
          'First item: ${response.isNotEmpty ? response.first : "N/A"}';
    }
    return response.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DioSpy Example'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Shake your device to open the HTTP Inspector',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection(
                      'Activities',
                      [
                        _buildButton(
                          'GET All Activities',
                          () => _executeRequest(
                            widget.apiService.getActivities,
                            'GET All Activities',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'GET Activity #5',
                          () => _executeRequest(
                            () => widget.apiService.getActivity(5),
                            'GET Activity #5',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'POST New Activity',
                          () => _executeRequest(
                            () => widget.apiService.createActivity(
                              id: 999,
                              title: 'Test Activity',
                              dueDate: DateTime.now().add(const Duration(days: 7)),
                              completed: false,
                            ),
                            'POST New Activity',
                          ),
                          Colors.blue,
                        ),
                        _buildButton(
                          'PUT Update Activity #1',
                          () => _executeRequest(
                            () => widget.apiService.updateActivity(
                              id: 1,
                              title: 'Updated Activity',
                              dueDate: DateTime.now(),
                              completed: true,
                            ),
                            'PUT Update Activity',
                          ),
                          Colors.orange,
                        ),
                        _buildButton(
                          'DELETE Activity #1',
                          () => _executeRequest(
                            () => widget.apiService.deleteActivity(1),
                            'DELETE Activity',
                          ),
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Books',
                      [
                        _buildButton(
                          'GET All Books',
                          () => _executeRequest(
                            widget.apiService.getBooks,
                            'GET All Books',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'GET Book #3',
                          () => _executeRequest(
                            () => widget.apiService.getBook(3),
                            'GET Book #3',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'POST New Book',
                          () => _executeRequest(
                            () => widget.apiService.createBook(
                              id: 888,
                              title: 'Flutter Development Guide',
                              description: 'A comprehensive guide to Flutter',
                              pageCount: 350,
                              excerpt: 'Learn Flutter from scratch...',
                              publishDate: DateTime.now(),
                            ),
                            'POST New Book',
                          ),
                          Colors.blue,
                        ),
                        _buildButton(
                          'PUT Update Book #2',
                          () => _executeRequest(
                            () => widget.apiService.updateBook(
                              id: 2,
                              title: 'Updated Book Title',
                              description: 'Updated description',
                              pageCount: 400,
                              excerpt: 'Updated excerpt',
                              publishDate: DateTime.now(),
                            ),
                            'PUT Update Book',
                          ),
                          Colors.orange,
                        ),
                        _buildButton(
                          'DELETE Book #2',
                          () => _executeRequest(
                            () => widget.apiService.deleteBook(2),
                            'DELETE Book',
                          ),
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Users',
                      [
                        _buildButton(
                          'GET All Users',
                          () => _executeRequest(
                            widget.apiService.getUsers,
                            'GET All Users',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'GET User #7',
                          () => _executeRequest(
                            () => widget.apiService.getUser(7),
                            'GET User #7',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'POST New User',
                          () => _executeRequest(
                            () => widget.apiService.createUser(
                              id: 777,
                              userName: 'testuser',
                              password: 'password123',
                            ),
                            'POST New User',
                          ),
                          Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Authors',
                      [
                        _buildButton(
                          'GET All Authors',
                          () => _executeRequest(
                            widget.apiService.getAuthors,
                            'GET All Authors',
                          ),
                          Colors.green,
                        ),
                        _buildButton(
                          'GET Authors by Book #1',
                          () => _executeRequest(
                            () => widget.apiService.getAuthorsByBook(1),
                            'GET Authors by Book',
                          ),
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Error Testing',
                      [
                        _buildButton(
                          'GET Invalid Endpoint (404)',
                          () => _executeRequest(
                            widget.apiService.getInvalidEndpoint,
                            'Invalid Endpoint',
                          ),
                          Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Response:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _result,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> buttons) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...buttons,
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, Color color) {
    final methodMatch = RegExp(r'^(GET|POST|PUT|DELETE|PATCH)').firstMatch(label);
    final method = methodMatch?.group(1) ?? '';
    final displayLabel = label.replaceFirst(RegExp(r'^(GET|POST|PUT|DELETE|PATCH)\s*'), '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: _loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        child: Row(
          children: [
            if (method.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  method,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                displayLabel,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
