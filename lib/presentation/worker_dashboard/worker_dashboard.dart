import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_job_widget.dart';
import './widgets/availability_toggle_widget.dart';
import './widgets/earnings_summary_widget.dart';
import './widgets/nearby_jobs_widget.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({Key? key}) : super(key: key);

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _availabilityStatus = 'Available';
  bool _hasActiveJob = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data for worker dashboard
  final Map<String, dynamic> workerData = {
    "name": "Rajesh Kumar",
    "location": "Pune, Maharashtra",
    "rating": 4.8,
    "completedJobs": 156,
    "skills": ["Harvesting", "Irrigation", "Planting"],
    "todayEarnings": 850.0,
    "weeklyEarnings": 4200.0,
    "pendingPayments": 1250.0,
    "activeJob": {
      "farmName": "Green Valley Farm",
      "jobType": "Harvesting",
      "startTime": "08:00 AM",
      "duration": "6 hours",
      "progress": 0.65,
      "location": "2.5 km away"
    }
  };

  final List<Map<String, dynamic>> nearbyJobs = [
    {
      "id": 1,
      "farmName": "Sunrise Organic Farm",
      "jobType": "Tomato Harvesting",
      "distance": "1.2 km",
      "hourlyRate": 120.0,
      "duration": "4-6 hours",
      "urgency": "High",
      "farmImage":
          "https://images.pexels.com/photos/2132227/pexels-photo-2132227.jpeg",
      "description":
          "Experienced workers needed for tomato harvesting. Early morning start preferred.",
      "requirements": ["Experience in harvesting", "Own transportation"],
      "farmerName": "Amit Sharma",
      "farmerRating": 4.6,
      "isBookmarked": false
    },
    {
      "id": 2,
      "farmName": "Golden Fields Agriculture",
      "jobType": "Wheat Planting",
      "distance": "2.8 km",
      "hourlyRate": 100.0,
      "duration": "8 hours",
      "urgency": "Medium",
      "farmImage":
          "https://images.pexels.com/photos/1595104/pexels-photo-1595104.jpeg",
      "description":
          "Seasonal wheat planting work available. Team work environment.",
      "requirements": ["Physical fitness", "Basic farming knowledge"],
      "farmerName": "Priya Patel",
      "farmerRating": 4.3,
      "isBookmarked": true
    },
    {
      "id": 3,
      "farmName": "Fresh Harvest Co-op",
      "jobType": "Irrigation Setup",
      "distance": "3.5 km",
      "hourlyRate": 150.0,
      "duration": "3-4 hours",
      "urgency": "Low",
      "farmImage":
          "https://images.pexels.com/photos/1595104/pexels-photo-1595104.jpeg",
      "description":
          "Technical irrigation system installation and maintenance work.",
      "requirements": ["Technical skills", "Irrigation experience"],
      "farmerName": "Suresh Reddy",
      "farmerRating": 4.9,
      "isBookmarked": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _hasActiveJob = workerData["activeJob"] != null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshJobs() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        // Simulate refreshing jobs data
      });
    }
  }

  void _toggleAvailability(String status) {
    setState(() {
      _availabilityStatus = status;
    });
  }

  void _toggleBookmark(int jobId) {
    setState(() {
      final jobIndex = nearbyJobs.indexWhere((job) => job["id"] == jobId);
      if (jobIndex != -1) {
        nearbyJobs[jobIndex]["isBookmarked"] =
            !nearbyJobs[jobIndex]["isBookmarked"];
      }
    });
  }

  void _applyForJob(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied for ${job["jobType"]} at ${job["farmName"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: job["farmImage"],
                            width: 20.w,
                            height: 15.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job["farmName"],
                                style: AppTheme.lightTheme.textTheme.titleLarge,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                job["jobType"],
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    size: 16,
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    job["distance"],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Job Details',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      job["description"],
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            'Hourly Rate',
                            '₹${job["hourlyRate"].toStringAsFixed(0)}',
                            Icons.currency_rupee,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildDetailCard(
                            'Duration',
                            job["duration"],
                            Icons.access_time,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Requirements',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    ...(job["requirements"] as List)
                        .map((req) => Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    size: 16,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    req,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _applyForJob(job);
                            },
                            child: const Text('Apply Now'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            size: 24,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(2.w),
          child: CircleAvatar(
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            child: Text(
              workerData["name"]
                  .toString()
                  .split(' ')
                  .map((name) => name[0])
                  .join(''),
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${workerData["name"].toString().split(' ')[0]}',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  size: 14,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 1.w),
                Text(
                  workerData["location"],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: CustomIconWidget(
              iconName: 'emergency',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Jobs'),
            Tab(text: 'Earnings'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildJobsTab(),
          _buildEarningsTab(),
          _buildProfileTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshJobs,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            AvailabilityToggleWidget(
              currentStatus: _availabilityStatus,
              onStatusChanged: _toggleAvailability,
            ),
            SizedBox(height: 2.h),
            EarningsSummaryWidget(
              todayEarnings: workerData["todayEarnings"],
              weeklyEarnings: workerData["weeklyEarnings"],
              pendingPayments: workerData["pendingPayments"],
            ),
            SizedBox(height: 2.h),
            if (_hasActiveJob) ...[
              ActiveJobWidget(
                activeJob: workerData["activeJob"],
              ),
              SizedBox(height: 2.h),
            ],
            NearbyJobsWidget(
              jobs: nearbyJobs,
              onApply: _applyForJob,
              onBookmark: _toggleBookmark,
              onViewDetails: _showJobDetails,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'work',
            size: 64,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'Job Search & Filtering',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Advanced job search coming soon',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/job-search-and-filtering');
            },
            child: const Text('Go to Job Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'account_balance_wallet',
            size: 64,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'Payment & Earnings',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Detailed earnings tracking',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/payment-and-earnings');
            },
            child: const Text('View Earnings'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 12.w,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  child: Text(
                    workerData["name"]
                        .toString()
                        .split(' ')
                        .map((name) => name[0])
                        .join(''),
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  workerData["name"],
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      size: 20,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${workerData["rating"]} (${workerData["completedJobs"]} jobs)',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: (workerData["skills"] as List)
                      .map((skill) => Chip(
                            label: Text(skill),
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.primaryContainer,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          _buildProfileOption('Edit Profile', Icons.edit, () {}),
          _buildProfileOption('Settings', Icons.settings, () {}),
          _buildProfileOption('Help & Support', Icons.help, () {}),
          _buildProfileOption('Logout', Icons.logout, () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login-screen',
              (route) => false,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon.codePoint.toString(),
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
        title: Text(title),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: AppTheme.lightTheme.colorScheme.surface,
      ),
    );
  }
}
