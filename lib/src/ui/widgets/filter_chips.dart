import 'package:flutter/material.dart';

import '../theme.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key, required this.selectedFilters, required this.onChanged});

  final Set<String> selectedFilters;
  final ValueChanged<Set<String>> onChanged;

  static const _statusFilters = ['2xx', '3xx', '4xx', '5xx'];
  static const _methodFilters = ['GET', 'POST', 'PUT', 'DELETE'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 6,
        children: [
          _buildChip('All'),
          _buildSeparator(),
          ..._statusFilters.map((f) => _buildChip(f)),
          _buildSeparator(),
          ..._methodFilters.map((f) => _buildChip(f)),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: 1,
      height: 20,
      color: DioSpyColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildChip(String label) {
    final isAll = label == 'All';
    final isSelected = isAll ? selectedFilters.isEmpty : selectedFilters.contains(label);

    return GestureDetector(
      onTap: () {
        final newFilters = Set<String>.from(selectedFilters);
        if (isAll) {
          newFilters.clear();
        } else {
          if (newFilters.contains(label)) {
            newFilters.remove(label);
          } else {
            newFilters.add(label);
          }
        }
        onChanged(newFilters);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? DioSpyColors.primary : DioSpyColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? DioSpyColors.primary : DioSpyColors.divider),
        ),
        child: Text(
          label,
          style: DioSpyTypo.t14.w500.copyWith(
            color: isSelected ? DioSpyColors.textOnPrimary : DioSpyColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
