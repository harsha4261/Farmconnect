import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionWidget extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelectionWidget({
    Key? key,
    required this.selectedRole,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Welcome message
          Text('Welcome to FarmConnect!',
              style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface)),

          SizedBox(height: 8.h),

          Text(
              'Choose your role to get started with our agricultural workforce platform.',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  height: 1.5)),

          SizedBox(height: 32.h),

          // Role selection cards
          _buildRoleCard(context,
              role: 'farmer',
              title: 'I\'m a Farmer',
              subtitle: 'Looking to hire skilled agricultural workers',
              imageUrl:
                  'https://images.pexels.com/photos/1459339/pexels-photo-1459339.jpeg?auto=compress&cs=tinysrgb&w=800',
              benefits: [
                'Post job opportunities',
                'Find verified workers',
                'Secure payment system',
                'GPS tracking for jobs',
              ],
              isSelected: selectedRole == 'farmer'),

          SizedBox(height: 20.h),

          _buildRoleCard(context,
              role: 'worker',
              title: 'I\'m a Worker',
              subtitle: 'Looking for agricultural work opportunities',
              imageUrl:
                  'https://images.pixabay.com/photo-2018/09/02/13/23/man-3649237_1280.jpg',
              benefits: [
                'Find nearby jobs',
                'Secure earnings',
                'Flexible scheduling',
                'Emergency support',
              ],
              isSelected: selectedRole == 'worker'),

          SizedBox(height: 24.h),

          // Additional info
          Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26)),
              child: Row(children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                    child: Text(
                        'You can change your role later in your profile settings.',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.primary))),
              ])),
        ]));
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String role,
    required String title,
    required String subtitle,
    required String imageUrl,
    required List<String> benefits,
    required bool isSelected,
  }) {
    return GestureDetector(
        onTap: () => onRoleSelected(role),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                    width: isSelected ? 2 : 1),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(26),
                            blurRadius: 10,
                            offset: const Offset(0, 5)),
                      ]
                    : [
                        BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 10,
                            offset: const Offset(0, 2)),
                      ]),
            child: Column(children: [
              Row(children: [
                // Role image
                Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.cover))),

                SizedBox(width: 16.w),

                // Role info
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(title,
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface)),
                      SizedBox(height: 4.h),
                      Text(subtitle,
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(179))),
                    ])),

                // Selection indicator
                Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).dividerColor,
                            width: 2)),
                    child: isSelected
                        ? Icon(Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 16.sp)
                        : null),
              ]),

              SizedBox(height: 16.h),

              // Benefits
              Column(
                  children: benefits.map((benefit) {
                return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(children: [
                      Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(51),
                              shape: BoxShape.circle),
                          child: Icon(Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                              size: 10.sp)),
                      SizedBox(width: 12.w),
                      Expanded(
                          child: Text(benefit,
                              style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(204)))),
                    ]));
              }).toList()),
            ])));
  }
}
