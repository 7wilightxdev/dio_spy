import 'package:flutter/material.dart';

import '../../utils/clipboard_helper.dart';
import 'toast_overlay.dart';

class CopyableText extends StatelessWidget {
  const CopyableText({
    super.key,
    required this.text,
    required this.child,
    this.toastMessage = 'Copied',
  });

  final String text;
  final Widget child;
  final String toastMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ClipboardHelper.copy(text);
        DioSpyToast.show(context, toastMessage);
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
