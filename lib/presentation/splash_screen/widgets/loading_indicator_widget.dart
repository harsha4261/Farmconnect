import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final String stage;
  final double progress;

  const LoadingIndicatorWidget({
    Key? key,
    required this.stage,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicator
        Container(
          width: 60.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(77),
            borderRadius: BorderRadius.circular(2.h),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60.w * progress,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Loading text
        Text(
          stage,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.white.withAlpha(230),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 8.h),

        // Dots animation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  (progress * 3 - index).clamp(0.3, 1.0),
                ),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
