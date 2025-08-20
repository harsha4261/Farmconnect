import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JobMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> jobs;
  final Function(Map<String, dynamic>) onJobTap;

  const JobMapWidget({
    Key? key,
    required this.jobs,
    required this.onJobTap,
  }) : super(key: key);

  @override
  State<JobMapWidget> createState() => _JobMapWidgetState();
}

class _JobMapWidgetState extends State<JobMapWidget> {
  Map<String, dynamic>? selectedJob;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map placeholder with job markers
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            image: const DecorationImage(
              image: NetworkImage(
                  'https://images.pexels.com/photos/2132227/pexels-photo-2132227.jpeg'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Stack(
            children: [
              // Map overlay
              Container(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
              ),

              // Job markers
              ...widget.jobs.asMap().entries.map((entry) {
                final index = entry.key;
                final job = entry.value;

                // Calculate position based on index for demo
                final left = (20 + (index * 15) % 60).toDouble();
                final top = (20 + (index * 20) % 50).toDouble();

                return Positioned(
                  left: left.w,
                  top: top.h,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedJob = job;
                      });
                      HapticFeedback.selectionClick();
                      widget.onJobTap(job);
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _getMarkerColor(job["urgency"] as String),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: _getJobIcon(job["cropType"] as String),
                        color: AppTheme.lightTheme.colorScheme.surface,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }).toList(),

              // Map controls
              Positioned(
                top: 2.h,
                right: 4.w,
                child: Column(
                  children: [
                    _buildMapControl(
                      icon: 'add',
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    SizedBox(height: 1.h),
                    _buildMapControl(
                      icon: 'remove',
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    SizedBox(height: 2.h),
                    _buildMapControl(
                      icon: 'my_location',
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ],
                ),
              ),

              // Legend
              Positioned(
                bottom: 2.h,
                left: 4.w,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Job Types',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      _buildLegendItem(
                          'Urgent', AppTheme.lightTheme.colorScheme.error),
                      _buildLegendItem(
                          'Priority', AppTheme.lightTheme.colorScheme.tertiary),
                      _buildLegendItem(
                          'Normal', AppTheme.lightTheme.colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Color _getMarkerColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'urgent':
        return AppTheme.lightTheme.colorScheme.error;
      case 'priority':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getJobIcon(String cropType) {
    switch (cropType.toLowerCase()) {
      case 'wheat':
      case 'rice':
        return 'grass';
      case 'vegetables':
        return 'local_florist';
      case 'fruits':
        return 'apple';
      case 'mixed':
        return 'agriculture';
      default:
        return 'eco';
    }
  }
}
