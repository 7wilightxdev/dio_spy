import 'package:flutter/material.dart';

import '../../models/http_call.dart';
import '../../utils/formatters.dart';
import '../theme.dart';
import '../widgets/json_viewer.dart';
import '../widgets/key_value_row.dart';
import '../widgets/section_card.dart';
import '../widgets/status_chip.dart';

class ResponseTab extends StatefulWidget {
  const ResponseTab({super.key, required this.call});
  final DioSpyHttpCall call;

  @override
  State<ResponseTab> createState() => _ResponseTabState();
}

class _ResponseTabState extends State<ResponseTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.call.loading) {
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

    final response = widget.call.response;
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
              KVRow(
                label: 'Status',
                valueWidget: StatusChip(statusCode: response.status),
              ),
              KVRow(
                label: 'Received',
                value: DioSpyFormatters.formatDateTime(response.time),
              ),
              KVRow(
                label: 'Duration',
                value: DioSpyFormatters.formatDuration(widget.call.duration),
              ),
              KVRow(
                label: 'Size',
                value: DioSpyFormatters.formatBytes(response.size),
              ),
            ],
          ),
        ),

        // Headers
        if (response.headers.isNotEmpty)
          SectionCard(
            initialExpanded: false,
            title: 'Headers (${response.headers.length})',
            child: KVRowGroup(entries: response.headers),
          ),

        // Body
        if (_hasBody(response.body))
          SectionCard(
            title: 'Body',
            child: JsonViewer(body: response.body),
          ),

        // Error
        if (widget.call.error != null)
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
                    widget.call.error!.error?.toString() ?? 'Unknown error',
                    style: DioSpyTypo.t14.copyWith(color: DioSpyColors.error),
                  ),
                ),
                if (widget.call.error!.stackTrace != null) ...[
                  const SizedBox(height: 8),
                  SectionCard(
                    title: 'Stacktrace',
                    initialExpanded: false,
                    child: SelectableText(
                      widget.call.error!.stackTrace.toString(),
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
