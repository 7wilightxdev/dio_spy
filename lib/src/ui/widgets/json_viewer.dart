import 'package:flutter/material.dart';

import '../../utils/clipboard_helper.dart';
import '../../utils/formatters.dart';
import '../theme.dart';
import 'toast_overlay.dart';
import 'package:json_visualizer/json_visualizer.dart';

class JsonViewer extends StatelessWidget {
  const JsonViewer({super.key, required this.body, this.maxLength = 100000});

  final dynamic body;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final formatted = DioSpyFormatters.formatBody(body);
    if (formatted.isEmpty) {
      return Text('Empty', style: DioSpyTypo.t16.secondary);
    }

    if (formatted.length > maxLength) {
      return _LargeBodyWidget(
        formattedBody: formatted,
        size: DioSpyFormatters.formatBytes(formatted.length),
      );
    }

    return JsonVisualizer(
      data: body,
      expandDepth: 3,
      fontSize: 14,
      onCopied: () => DioSpyToast.show(context),
    );
  }
}

class _LargeBodyWidget extends StatefulWidget {
  const _LargeBodyWidget({required this.formattedBody, required this.size});
  final String formattedBody;
  final String size;

  @override
  State<_LargeBodyWidget> createState() => _LargeBodyWidgetState();
}

class _LargeBodyWidgetState extends State<_LargeBodyWidget> {
  bool _showFull = false;

  @override
  Widget build(BuildContext context) {
    if (_showFull) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                ClipboardHelper.copy(widget.formattedBody);
                DioSpyToast.show(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.copy_rounded, size: 16, color: DioSpyColors.textTertiary),
              ),
            ),
          ),
          SelectableText(widget.formattedBody, style: DioSpyTypo.t12.secondary),
        ],
      );
    }

    return Column(
      children: [
        Text('Body too large (${widget.size})', style: DioSpyTypo.t16.secondary),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _showFull = true),
          child: Text(
            'Show anyway',
            style: DioSpyTypo.t16.w500.primary.copyWith(
              color: DioSpyColors.info,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
