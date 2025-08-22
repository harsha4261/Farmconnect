import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingDetailsModal extends StatefulWidget {
  final Map<String, dynamic> booking;

  const BookingDetailsModal({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  State<BookingDetailsModal> createState() => _BookingDetailsModalState();
}

class _BookingDetailsModalState extends State<BookingDetailsModal>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'cancelled':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booking['jobTitle'] as String,
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Booking ID: ${widget.booking['id']}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(widget.booking['status'] as String),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (widget.booking['status'] as String).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Timeline'),
                  Tab(text: 'Contact'),
                ],
              ),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(scrollController),
                    _buildTimelineTab(scrollController),
                    _buildContactTab(scrollController),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Information
          _buildSectionCard(
            title: 'Job Information',
            icon: 'work',
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'group',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Assigned Team: ${widget.booking['teamName'] ?? 'None'}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildInfoRow('Job Type', widget.booking['jobType'] as String),
              _buildInfoRow('Duration', widget.booking['duration'] as String),
              _buildInfoRow(
                  'Start Date', widget.booking['startDate'] as String),
              _buildInfoRow('End Date', widget.booking['endDate'] as String),
              _buildInfoRow('Location', widget.booking['location'] as String),
              SizedBox(height: 2.h),
              Text(
                'Description',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                widget.booking['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Skills Required
          _buildSectionCard(
            title: 'Skills Required',
            icon: 'psychology',
            children: [
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children:
                    (widget.booking['skillsRequired'] as List).map((skill) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      skill as String,
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Payment Information
          _buildSectionCard(
            title: 'Payment Information',
            icon: 'payment',
            children: [
              _buildInfoRow(
                  'Amount', widget.booking['paymentAmount'] as String),
              _buildInfoRow('Status',
                  (widget.booking['paymentStatus'] as String).toUpperCase()),
            ],
          ),

          if (widget.booking['cancellationReason'] != null) ...[
            SizedBox(height: 3.h),
            _buildSectionCard(
              title: 'Cancellation Details',
              icon: 'cancel',
              children: [
                Text(
                  widget.booking['cancellationReason'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorLight,
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(ScrollController scrollController) {
    final timeline = widget.booking['timeline'] as List;

    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Progress Timeline',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: timeline.length,
            itemBuilder: (context, index) {
              final item = timeline[index] as Map<String, dynamic>;
              final isCompleted = item['completed'] as bool;
              final isLast = index == timeline.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline indicator
                  Column(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 8.h,
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                        ),
                    ],
                  ),
                  SizedBox(width: 4.w),

                  // Timeline content
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 4.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['status'] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if ((item['date'] as String).isNotEmpty) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              item['date'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildContactTab(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Worker Contact
          _buildContactCard(
            title: 'Worker Contact',
            name: widget.booking['workerName'] as String,
            photo: widget.booking['workerPhoto'] as String,
            role: 'Agricultural Worker',
          ),

          SizedBox(height: 3.h),

          // Farmer Contact
          _buildContactCard(
            title: 'Farmer Contact',
            name: widget.booking['farmerName'] as String,
            photo: widget.booking['farmerPhoto'] as String,
            role: 'Farm Owner',
          ),

          SizedBox(height: 3.h),

          // Emergency Contact
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'emergency',
                        color: AppTheme.errorLight,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Emergency Contact',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.errorLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.booking['emergencyContact'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling emergency contact...'),
                            backgroundColor: AppTheme.errorLight,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'call',
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text('Call Emergency Contact'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorLight,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String name,
    required String photo,
    required String role,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 8.w,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline,
                  child: CustomImageWidget(
                    imageUrl: photo,
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        role,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening chat with $name'),
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                        ),
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'chat',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    label: Text('Message'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling $name...'),
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                        ),
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'call',
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text('Call'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
