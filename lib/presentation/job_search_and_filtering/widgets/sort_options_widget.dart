import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortSelected;

  const SortOptionsWidget({
    Key? key,
    required this.currentSort,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'title': 'Distance', 'subtitle': 'Nearest first', 'icon': 'location_on'},
      {
        'title': 'Pay Rate',
        'subtitle': 'Highest first',
        'icon': 'currency_rupee'
      },
      {'title': 'Start Date', 'subtitle': 'Earliest first', 'icon': 'schedule'},
      {'title': 'Duration', 'subtitle': 'Shortest first', 'icon': 'timer'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Text(
                  'Sort by',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3)),

          // Sort options
          ...sortOptions.map((option) {
            final isSelected = currentSort == option['title'];
            return ListTile(
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: option['icon'] as String,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              title: Text(
                option['title'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              subtitle: Text(
                option['subtitle'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: isSelected
                  ? CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    )
                  : null,
              onTap: () {
                onSortSelected(option['title'] as String);
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            );
          }).toList(),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
