import 'package:flutter/material.dart';

import '../../models/http_call.dart';
import '../../utils/formatters.dart';
import '../theme.dart';
import '../widgets/json_viewer.dart';
import '../widgets/key_value_row.dart';
import '../widgets/section_card.dart';
import '../widgets/status_chip.dart';

class ResponseTab extends StatelessWidget {
  const ResponseTab({super.key, required this.call});
  final DioSpyHttpCall call;

  @override
  Widget build(BuildContext context) {
    if (call.loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 2, color: DioSpyColors.primary),
            const SizedBox(height: 12),
            Text('Awaiting response...', style: DioSpyTypo.t16.secondary),
          ],
        ),
      );
    }

    final response = call.response;
    if (response == null) {
      return Center(child: Text('No response data', style: DioSpyTypo.t16.secondary));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // General
        SectionCard(
          title: 'General',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyValueRow(
                label: 'Status',
                valueWidget: StatusChip(statusCode: response.status),
              ),
              KeyValueRow(
                label: 'Received',
                value: DioSpyFormatters.formatDateTime(response.time),
              ),
              KeyValueRow(
                label: 'Duration',
                value: DioSpyFormatters.formatDuration(call.duration),
              ),
              KeyValueRow(
                label: 'Size',
                value: DioSpyFormatters.formatBytes(response.size),
              ),
            ],
          ),
        ),

        // Headers
        if (response.headers.isNotEmpty)
          SectionCard(
            title: 'Headers (${response.headers.length})',
            child: Column(
              children: response.headers.entries
                  .map((e) => KeyValueRow(label: e.key, value: e.value))
                  .toList(),
            ),
          ),

        // Body
        if (_hasBody(response.body))
          SectionCard(
            title: 'Body',
            child: JsonViewer(body: response.body),
          ),

        // Error
        if (call.error != null)
          SectionCard(
            title: 'Error',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DioSpyColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    call.error!.error?.toString() ?? 'Unknown error',
                    style: DioSpyTypo.t14.copyWith(color: DioSpyColors.error),
                  ),
                ),
                if (call.error!.stackTrace != null) ...[
                  const SizedBox(height: 8),
                  SectionCard(
                    title: 'Stacktrace',
                    initialExpanded: false,
                    child: SelectableText(
                      call.error!.stackTrace.toString(),
                      style: DioSpyTypo.t12.secondary,
                    ),
                  ),
                ],
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
