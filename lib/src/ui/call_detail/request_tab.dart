import 'package:flutter/material.dart';

import '../../models/http_call.dart';
import '../../utils/formatters.dart';
import '../theme.dart';
import '../widgets/copyable_text.dart';
import '../widgets/json_viewer.dart';
import '../widgets/key_value_row.dart';
import '../widgets/section_card.dart';

class RequestTab extends StatelessWidget {
  const RequestTab({super.key, required this.call});
  final DioSpyHttpCall call;

  @override
  Widget build(BuildContext context) {
    final request = call.request;
    if (request == null) {
      return Center(child: Text('No request data', style: DioSpyTypo.t16.secondary));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // General
        SectionCard(
          title: 'General',
          child: Column(
            children: [
              KeyValueRow(label: 'URL', value: call.uri),
              KeyValueRow(label: 'Method', value: call.method),
              KeyValueRow(label: 'Started', value: DioSpyFormatters.formatDateTime(request.time)),
              KeyValueRow(
                label: 'Duration',
                value: DioSpyFormatters.formatDuration(call.duration),
              ),
              KeyValueRow(label: 'Secure', value: call.secure ? 'Yes (HTTPS)' : 'No (HTTP)'),
              KeyValueRow(label: 'Size', value: DioSpyFormatters.formatBytes(request.size)),
            ],
          ),
        ),

        // Headers
        if (request.headers.isNotEmpty)
          SectionCard(
            title: 'Headers (${request.headers.length})',
            child: Column(
              children: request.headers.entries
                  .map((e) => KeyValueRow(label: e.key, value: e.value))
                  .toList(),
            ),
          ),

        // Cookies
        if (request.cookies.isNotEmpty)
          SectionCard(
            title: 'Cookies (${request.cookies.length})',
            child: Column(
              children: request.cookies.entries
                  .map((e) => KeyValueRow(label: e.key, value: e.value))
                  .toList(),
            ),
          ),

        // Query Parameters
        if (request.queryParameters.isNotEmpty)
          SectionCard(
            title: 'Query Parameters (${request.queryParameters.length})',
            child: Column(
              children: request.queryParameters.entries
                  .map((e) => KeyValueRow(label: e.key, value: e.value.toString()))
                  .toList(),
            ),
          ),

        // Body
        if (_hasBody(request.body))
          SectionCard(
            title: 'Body',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form data fields
                if (request.formDataFields != null && request.formDataFields!.isNotEmpty) ...[
                  Text('Fields', style: DioSpyTypo.t16.secondary),
                  const SizedBox(height: 4),
                  ...request.formDataFields!.map(
                    (f) => KeyValueRow(label: f.name, value: f.value),
                  ),
                  const SizedBox(height: 8),
                ],
                // Form data files
                if (request.formDataFiles != null && request.formDataFiles!.isNotEmpty) ...[
                  Text('Files', style: DioSpyTypo.t16.secondary),
                  const SizedBox(height: 4),
                  ...request.formDataFiles!.map(
                    (f) => CopyableText(
                      text: f.fileName,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${f.fileName} (${f.contentType}, ${DioSpyFormatters.formatBytes(f.length)})',
                          style: DioSpyTypo.t16.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                // Raw body (if not form data)
                if (request.formDataFields == null || request.formDataFields!.isEmpty)
                  JsonViewer(body: request.body),
              ],
            ),
          ),
      ],
    );
  }

  bool _hasBody(dynamic body) {
    if (body == null) return false;
    if (body is String && body.isEmpty) return false;
    return true;
  }
}
