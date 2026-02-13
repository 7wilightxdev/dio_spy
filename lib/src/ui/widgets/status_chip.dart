import 'package:flutter/material.dart';

import '../../utils/formatters.dart';
import '../theme.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.statusCode});

  final int? statusCode;

  @override
  Widget build(BuildContext context) {
    final color = DioSpyColors.statusColor(statusCode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        DioSpyFormatters.formatStatusCode(statusCode),
        style: DioSpyTypo.t14.w600.copyWith(color: color),
      ),
    );
  }
}
