import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvailabilityToggleWidget extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const AvailabilityToggleWidget({
    Key? key,
    required this.currentStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _getStatusColor(currentStatus).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(currentStatus).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: _getStatusColor(currentStatus),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Text(
                      currentStatus,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _getStatusColor(currentStatus),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'location_on',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                  'Available',
                  Icons.check_circle,
                  AppTheme.lightTheme.colorScheme.primary,
                  currentStatus == 'Available',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatusButton(
                  'Busy',
                  Icons.work,
                  Colors.orange,
                  currentStatus == 'Busy',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatusButton(
                  'Offline',
                  Icons.do_not_disturb,
                  Colors.grey,
                  currentStatus == 'Offline',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
      String status, IconData icon, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => onStatusChanged(status),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon.codePoint.toString(),
              size: 20,
              color: isSelected ? Colors.white : color,
            ),
            SizedBox(height: 0.5.h),
            Text(
              status,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Busy':
        return Colors.orange;
      case 'Offline':
        return Colors.grey;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
