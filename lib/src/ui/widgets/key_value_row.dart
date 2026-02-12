import 'package:flutter/material.dart';

import '../theme.dart';
import 'copyable_text.dart';

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
    this.copyable = true,
  }) : assert(value != null || valueWidget != null, 'Either value or valueWidget must be provided');

  final String label;
  final String? value;
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
        style: DioSpyTypo.t14.w500,
        maxLines: 3,
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
          Expanded(flex: 1, child: Text("$label:", style: DioSpyTypo.t14.secondary)),
          const SizedBox(width: 12),
          Flexible(flex: 2, child: effectiveValueWidget),
        ],
      ),
    );
  }
}
