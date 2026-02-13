import 'package:flutter/material.dart';

import '../theme.dart';
import 'copyable_text.dart';

class KVRowGroup extends StatelessWidget {
  const KVRowGroup({super.key, required this.entries});

  final Map<String, dynamic> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.entries.map((e) => KVRow(label: e.key, value: e.value.toString())).toList(),
    );
  }
}

class KVRow extends StatelessWidget {
  const KVRow({
    super.key,
    required this.label,
    this.value,
    this.valueColor,
    this.valueWidget,
    this.copyable = true,
  }) : assert(value != null || valueWidget != null, 'Either value or valueWidget must be provided');

  final String label;
  final String? value;
  final Color? valueColor;
  final Widget? valueWidget;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    Widget effectiveValueWidget = const SizedBox.shrink();

    if (valueWidget != null) {
      effectiveValueWidget = valueWidget!;
    } else if (value != null) {
      effectiveValueWidget = Text(
        value!,
        style: DioSpyTypo.t14.copyWith(
          color: valueColor ?? DioSpyColors.textSecondary,
        ),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      );
      if (copyable) {
        effectiveValueWidget = CopyableText(
          text: value!,
          child: effectiveValueWidget,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: Text("$label:", style: DioSpyTypo.t14.w500)),
          const SizedBox(width: 12),
          Flexible(flex: 2, child: effectiveValueWidget),
        ],
      ),
    );
  }
}
