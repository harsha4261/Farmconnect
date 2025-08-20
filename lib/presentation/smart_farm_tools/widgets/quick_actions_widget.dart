import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final String selectedTool;
  final Function(String) onToolSelected;

  const QuickActionsWidget({
    super.key,
    required this.selectedTool,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickAction(
          context,
          'save',
          'Save Report',
          () {
            // Handle save report
          },
        ),
        _buildQuickAction(
          context,
          'share',
          'Share Insights',
          () {
            // Handle share insights
          },
        ),
        _buildQuickAction(
          context,
          'history',
          'View History',
          () {
            // Handle view history
          },
        ),
        _buildQuickAction(
          context,
          'help',
          'Get Help',
          () {
            // Handle get help
          },
        ),
      ],
    );
  }

  Widget _buildQuickAction(
      BuildContext context, String icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
