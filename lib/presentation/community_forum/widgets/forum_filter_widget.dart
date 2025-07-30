import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ForumFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ForumFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'All Posts', 'icon': 'forum'},
      {'key': 'recent', 'label': 'Recent', 'icon': 'schedule'},
      {'key': 'popular', 'label': 'Popular', 'icon': 'trending_up'},
      {'key': 'nearby', 'label': 'Nearby', 'icon': 'location_on'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter by:',
            style: AppTheme.lightTheme.textTheme.labelMedium,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  final isSelected = selectedFilter == filter['key'];
                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: FilterChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: filter['icon']!,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(filter['label']!),
                        ],
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          onFilterChanged(filter['key']!);
                        }
                      },
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      selectedColor: AppTheme.lightTheme.colorScheme.primary,
                      labelStyle:
                          AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
