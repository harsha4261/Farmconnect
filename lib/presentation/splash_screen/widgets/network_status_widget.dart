import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class NetworkStatusWidget extends StatelessWidget {
  final bool hasConnectivity;

  const NetworkStatusWidget({
    Key? key,
    required this.hasConnectivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hasConnectivity) {
      return const SizedBox.shrink();
    }

    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
            color: Colors.orange.withAlpha(230),
            borderRadius: BorderRadius.only()),
        child: Row(children: [
          Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
              child: Text(
                  'Poor connectivity detected. Optimizing for rural networks...',
                  style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500))),
        ]));
  }
}
