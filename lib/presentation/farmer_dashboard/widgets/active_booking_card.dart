import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_glassmorphism_card.dart';

class ActiveBookingCard extends StatefulWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onMessageTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onModifyTap;
  final VoidCallback? onCancelTap;

  const ActiveBookingCard({
    Key? key,
    required this.booking,
    this.onMessageTap,
    this.onLocationTap,
    this.onModifyTap,
    this.onCancelTap,
  }) : super(key: key);

  @override
  State<ActiveBookingCard> createState() => _ActiveBookingCardState();
}

class _ActiveBookingCardState extends State<ActiveBookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'confirmed':
        return AppTheme.infoLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.booking['status']);
    final statusText = _getStatusText(widget.booking['status']);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: CustomGlassmorphismCard(
                padding: EdgeInsets.all(4.w),
                borderRadius: BorderRadius.circular(20),
                opacity: 0.05,
                blurRadius: 25,
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      children: [
                        // Worker Avatar
                        Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: statusColor,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.booking['workerPhoto'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppTheme.backgroundGradientLight.first,
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'person',
                                    color: AppTheme.textSecondaryLight,
                                    size: 24,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppTheme.backgroundGradientLight.first,
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'person',
                                    color: AppTheme.textSecondaryLight,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 4.w),

                        // Worker Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.booking['workerName'],
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            statusColor.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'work',
                                    color: AppTheme.textSecondaryLight,
                                    size: 16,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    widget.booking['jobType'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.textSecondaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => CustomIconWidget(
                                        iconName: index <
                                                widget.booking['rating'].floor()
                                            ? 'star'
                                            : 'star_border',
                                        color: AppTheme.accentLight,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    widget.booking['rating'].toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Job Details
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: 'schedule',
                            title: 'Time',
                            value: widget.booking['timeRemaining'],
                            color: AppTheme.infoLight,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildInfoCard(
                            icon: 'location_on',
                            title: 'Location',
                            value: widget.booking['location'],
                            color: AppTheme.successLight,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildInfoCard(
                            icon: 'attach_money',
                            title: 'Rate',
                            value: widget.booking['hourlyRate'],
                            color: AppTheme.accentLight,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: 'message',
                            label: 'Message',
                            color: AppTheme.infoLight,
                            onTap: widget.onMessageTap,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildActionButton(
                            icon: 'location_on',
                            label: 'Location',
                            color: AppTheme.successLight,
                            onTap: widget.onLocationTap,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildActionButton(
                            icon: 'edit',
                            label: 'Modify',
                            color: AppTheme.warningLight,
                            onTap: widget.onModifyTap,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildActionButton(
                            icon: 'cancel',
                            label: 'Cancel',
                            color: AppTheme.errorLight,
                            onTap: widget.onCancelTap,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
