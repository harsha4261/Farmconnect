import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_animated_button.dart';
import '../../widgets/custom_glassmorphism_card.dart';
import '../../widgets/custom_gradient_container.dart';
import './widgets/active_booking_card.dart';
import './widgets/quick_action_card.dart';
import './widgets/recent_activity_item.dart';
import './widgets/weather_widget.dart';
import '../../core/services/config/app_config_service.dart';
import '../../core/models/nav_item.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerAnimationController;
  final _config = AppConfigService();
  List<NavItem> _navItems = [
    NavItem(title: 'Dashboard', icon: 'dashboard', route: '/farmer-dashboard', roles: const ['farmer']),
    NavItem(title: 'Search', icon: 'search', route: '/job-search-and-filtering', roles: const ['farmer']),
    NavItem(title: 'Bookings', icon: 'book', route: '/booking-management', roles: const ['farmer']),
    NavItem(title: 'Profile', icon: 'person', route: '/profile-management', roles: const ['farmer']),
  ];
  late Animation<double> _headerAnimation;
  bool _isConnected = true;
  bool _isRefreshing = false;

  // Mock data for active bookings
  final List<Map<String, dynamic>> activeBookings = [
    {
      "id": 1,
      "workerName": "Rajesh Kumar",
      "workerPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobType": "Harvesting",
      "status": "active",
      "timeRemaining": "2 hours 30 mins",
      "location": "Field A-12",
      "hourlyRate": "\$15/hour",
      "rating": 4.8,
      "phone": "+91 9876543210"
    },
    {
      "id": 2,
      "workerName": "Priya Sharma",
      "workerPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobType": "Planting",
      "status": "pending",
      "timeRemaining": "Starts in 1 hour",
      "location": "Field B-8",
      "hourlyRate": "\$12/hour",
      "rating": 4.6,
      "phone": "+91 9876543211"
    },
    {
      "id": 3,
      "workerName": "Amit Singh",
      "workerPhoto":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobType": "Irrigation",
      "status": "confirmed",
      "timeRemaining": "Tomorrow 8:00 AM",
      "location": "Field C-5",
      "hourlyRate": "\$18/hour",
      "rating": 4.9,
      "phone": "+91 9876543212"
    }
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "application",
      "title": "New Application Received",
      "description": "Sunita Devi applied for Weeding job",
      "timestamp": "2 minutes ago",
      "icon": "person_add"
    },
    {
      "id": 2,
      "type": "confirmation",
      "title": "Booking Confirmed",
      "description": "Rajesh Kumar confirmed for Harvesting",
      "timestamp": "15 minutes ago",
      "icon": "check_circle"
    },
    {
      "id": 3,
      "type": "payment",
      "title": "Payment Processed",
      "description": "\$240 paid to Priya Sharma",
      "timestamp": "1 hour ago",
      "icon": "payment"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _navItems.length, vsync: this);
    // Live update bottom tabs from Firestore
    _config.navItemsStream('farmer').listen((items) {
      // Guard against TabController length mismatches by only applying
      // dynamic config when it matches the expected tabs count (4).
      if (items.isNotEmpty && items.length == 4) {
        setState(() {
          _navItems = items;
          _tabController.dispose();
          _tabController = TabController(length: _navItems.length, vsync: this);
        });
      }
    });
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showBookingContextMenu(
      BuildContext context, Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomGlassmorphismCard(
        margin: EdgeInsets.all(4.w),
        borderRadius: BorderRadius.circular(24),
        opacity: 0.9,
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Booking Options',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildContextMenuItem(
                icon: 'star',
                title: 'Rate Worker',
                onTap: () {
                  Navigator.pop(context);
                  // Handle rate worker
                },
              ),
              _buildContextMenuItem(
                icon: 'report',
                title: 'Report Issue',
                onTap: () {
                  Navigator.pop(context);
                  // Handle report issue
                },
              ),
              _buildContextMenuItem(
                icon: 'copy',
                title: 'Duplicate Job',
                onTap: () {
                  Navigator.pop(context);
                  // Handle duplicate job
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomGradientContainer(
        gradientType: GradientType.background,
        child: Column(
          children: [
            // Enhanced App Bar with beautiful gradient
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                  child: Opacity(
                    opacity: _headerAnimation.value,
                    child: CustomGradientContainer(
                      gradientType: GradientType.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: SafeArea(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Column(
                            children: [
                              // Header Row
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'agriculture',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 32,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      'FarmConnect',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  CustomGlassmorphismCard(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 1.h),
                                    opacity: 0.2,
                                    blurRadius: 10,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 2.w,
                                          height: 2.w,
                                          decoration: BoxDecoration(
                                            color: _isConnected
                                                ? Colors.green
                                                : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          _isConnected ? 'Online' : 'Offline',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              // Enhanced Tab Bar
                              CustomGlassmorphismCard(
                                padding: EdgeInsets.all(1.w),
                                opacity: 0.2,
                                blurRadius: 15,
                                child: TabBar(
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  tabs: [
                                    Tab(
                                      icon: CustomIconWidget(
                                        iconName: 'dashboard',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 20,
                                      ),
                                      text: 'Dashboard',
                                    ),
                                    Tab(
                                      icon: CustomIconWidget(
                                        iconName: 'search',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 20,
                                      ),
                                      text: 'Search',
                                    ),
                                    Tab(
                                      icon: CustomIconWidget(
                                        iconName: 'book',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 20,
                                      ),
                                      text: 'Bookings',
                                    ),
                                    Tab(
                                      icon: CustomIconWidget(
                                        iconName: 'person',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 20,
                                      ),
                                      text: 'Profile',
                                    ),
                                  ],
                                  labelStyle: AppTheme
                                      .lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelStyle: AppTheme
                                      .lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard Tab
                  RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),

                          // Enhanced Weather Widget
                          WeatherWidget(),

                          SizedBox(height: 3.h),

                          // Quick Actions Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              'Quick Actions',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          SizedBox(
                            height: 14.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              children: [
                                QuickActionCard(
                                  title: 'Post New Job',
                                  icon: 'add_circle',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  onTap: () {
                                    // Handle post new job
                                  },
                                ),
                                SizedBox(width: 4.w),
                                QuickActionCard(
                                  title: 'Find Workers',
                                  icon: 'search',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/job-search-and-filtering');
                                  },
                                ),
                                SizedBox(width: 4.w),
                                QuickActionCard(
                                  title: 'View Applications',
                                  icon: 'assignment',
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/booking-management');
                                  },
                                ),
                                SizedBox(width: 4.w),
                                QuickActionCard(
                                  title: 'Emergency',
                                  icon: 'emergency',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  onTap: () {
                                    // Handle emergency contacts
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Active Bookings Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Active Bookings',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/booking-management');
                                  },
                                  child: Text(
                                    'View All',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activeBookings.length,
                            itemBuilder: (context, index) {
                              final booking = activeBookings[index];
                              return GestureDetector(
                                onLongPress: () =>
                                    _showBookingContextMenu(context, booking),
                                child: ActiveBookingCard(
                                  booking: booking,
                                  onMessageTap: () {
                                    // Handle message worker
                                  },
                                  onLocationTap: () {
                                    // Handle view location
                                  },
                                  onModifyTap: () {
                                    // Handle modify job
                                  },
                                  onCancelTap: () {
                                    // Handle cancel booking
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Cancel Booking'),
                                        content: Text(
                                            'Are you sure you want to cancel this booking?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('No'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Handle cancel confirmation
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppTheme
                                                  .lightTheme.colorScheme.error,
                                            ),
                                            child: Text('Yes, Cancel'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 4.h),

                          // Recent Activity Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              'Recent Activity',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recentActivities.length,
                            itemBuilder: (context, index) {
                              final activity = recentActivities[index];
                              return RecentActivityItem(activity: activity);
                            },
                          ),

                          SizedBox(height: 12.h), // Bottom padding for FAB
                        ],
                      ),
                    ),
                  ),

                  // Search Tab
                  Center(
                    child: CustomGlassmorphismCard(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 64,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Search Workers',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Find skilled agricultural workers in your area',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3.h),
                          CustomAnimatedButton(
                            text: 'Go to Search',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/job-search-and-filtering');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bookings Tab
                  Center(
                    child: CustomGlassmorphismCard(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'book',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 64,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Manage Bookings',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'View and manage all your worker bookings',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3.h),
                          CustomAnimatedButton(
                            text: 'View Bookings',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/booking-management');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Profile Tab
                  Center(
                    child: CustomGlassmorphismCard(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 64,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Profile Settings',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Manage your account and preferences',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3.h),
                          CustomAnimatedButton(
                            text: 'Logout',
                            buttonStyle: ButtonStyle.error,
                            onPressed: () {
                              Navigator.pushNamed(context, '/login-screen');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Handle quick job posting
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Post Job',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              elevation: 12,
            )
          : null,
    );
  }
}
