import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AccuracyIndicatorWidget extends StatelessWidget {
  final double accuracy;

  const AccuracyIndicatorWidget({
    super.key,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    Color accuracyColor;
    String accuracyText;

    if (accuracy >= 0.9) {
      accuracyColor = Colors.green;
      accuracyText = 'Excellent';
    } else if (accuracy >= 0.8) {
      accuracyColor = Colors.lightGreen;
      accuracyText = 'Good';
    } else if (accuracy >= 0.7) {
      accuracyColor = Colors.orange;
      accuracyText = 'Fair';
    } else {
      accuracyColor = Colors.red;
      accuracyText = 'Poor';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: accuracyColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            color: accuracyColor,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            '${(accuracy * 100).toInt()}% $accuracyText',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: accuracyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
