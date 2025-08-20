import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const ProgressIndicatorWidget({
    Key? key,
    required this.steps,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator
          Row(
            children: List.generate(steps.length, (index) {
              final isActive = index <= currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    // Circle indicator
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: isActive
                          ? Icon(
                              index < currentStep ? Icons.check : Icons.circle,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 12.sp,
                            )
                          : null,
                    ),

                    // Connection line
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2.h,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 12.h),

          // Current step title
          Text(
            steps[currentStep],
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 4.h),

          // Progress text
          Text(
            'Step ${currentStep + 1} of ${steps.length}',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}
