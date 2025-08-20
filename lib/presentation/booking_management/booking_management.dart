import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_card_widget.dart';
import './widgets/booking_details_modal.dart';
import './widgets/booking_filter_widget.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({Key? key}) : super(key: key);

  @override
  State<BookingManagement> createState() => _BookingManagementState();
}

class _BookingManagementState extends State<BookingManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for bookings
  final List<Map<String, dynamic>> _allBookings = [
    {
      "id": "BK001",
      "farmerName": "John Smith",
      "workerName": "Maria Rodriguez",
      "farmerPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "workerPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobTitle": "Corn Harvesting",
      "jobType": "Harvesting",
      "location": "Green Valley Farm, CA",
      "status": "active",
      "startDate": "2024-01-15",
      "endDate": "2024-01-20",
      "duration": "5 days",
      "paymentAmount": "\$750.00",
      "paymentStatus": "pending",
      "description":
          "Harvest corn crop across 50 acres. Experience with harvesting equipment required.",
      "skillsRequired": ["Harvesting", "Equipment Operation", "Physical Labor"],
      "timeline": [
        {"status": "Applied", "date": "2024-01-10", "completed": true},
        {"status": "Confirmed", "date": "2024-01-12", "completed": true},
        {"status": "Started", "date": "2024-01-15", "completed": true},
        {"status": "Completed", "date": "", "completed": false},
        {"status": "Paid", "date": "", "completed": false}
      ],
      "unreadMessages": 2,
      "rating": 0,
      "gpsEnabled": true,
      "emergencyContact": "+1-555-0123"
    },
    {
      "id": "BK002",
      "farmerName": "Sarah Johnson",
      "workerName": "Carlos Martinez",
      "farmerPhoto":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "workerPhoto":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobTitle": "Tomato Planting",
      "jobType": "Planting",
      "location": "Sunshine Farms, TX",
      "status": "pending",
      "startDate": "2024-01-25",
      "endDate": "2024-01-27",
      "duration": "3 days",
      "paymentAmount": "\$450.00",
      "paymentStatus": "pending",
      "description":
          "Plant tomato seedlings in greenhouse environment. Knowledge of irrigation systems preferred.",
      "skillsRequired": ["Planting", "Irrigation", "Greenhouse Work"],
      "timeline": [
        {"status": "Applied", "date": "2024-01-18", "completed": true},
        {"status": "Confirmed", "date": "", "completed": false},
        {"status": "Started", "date": "", "completed": false},
        {"status": "Completed", "date": "", "completed": false},
        {"status": "Paid", "date": "", "completed": false}
      ],
      "unreadMessages": 0,
      "rating": 0,
      "gpsEnabled": false,
      "emergencyContact": "+1-555-0456"
    },
    {
      "id": "BK003",
      "farmerName": "Michael Brown",
      "workerName": "Ana Garcia",
      "farmerPhoto":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "workerPhoto":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobTitle": "Irrigation System Setup",
      "jobType": "Irrigation",
      "location": "Desert Bloom Ranch, AZ",
      "status": "completed",
      "startDate": "2024-01-05",
      "endDate": "2024-01-08",
      "duration": "4 days",
      "paymentAmount": "\$600.00",
      "paymentStatus": "paid",
      "description":
          "Install and configure drip irrigation system for vegetable crops.",
      "skillsRequired": ["Irrigation", "Technical Skills", "Problem Solving"],
      "timeline": [
        {"status": "Applied", "date": "2024-01-01", "completed": true},
        {"status": "Confirmed", "date": "2024-01-02", "completed": true},
        {"status": "Started", "date": "2024-01-05", "completed": true},
        {"status": "Completed", "date": "2024-01-08", "completed": true},
        {"status": "Paid", "date": "2024-01-10", "completed": true}
      ],
      "unreadMessages": 0,
      "rating": 5,
      "gpsEnabled": false,
      "emergencyContact": "+1-555-0789"
    },
    {
      "id": "BK004",
      "farmerName": "Lisa Wilson",
      "workerName": "Roberto Silva",
      "farmerPhoto":
          "https://images.pexels.com/photos/1181424/pexels-photo-1181424.jpeg?auto=compress&cs=tinysrgb&w=400",
      "workerPhoto":
          "https://images.pexels.com/photos/1212984/pexels-photo-1212984.jpeg?auto=compress&cs=tinysrgb&w=400",
      "jobTitle": "Wheat Field Maintenance",
      "jobType": "Maintenance",
      "location": "Golden Fields Farm, KS",
      "status": "cancelled",
      "startDate": "2024-01-12",
      "endDate": "2024-01-15",
      "duration": "4 days",
      "paymentAmount": "\$500.00",
      "paymentStatus": "refunded",
      "description":
          "General maintenance work including weeding and pest control.",
      "skillsRequired": ["Maintenance", "Pest Control", "Field Work"],
      "timeline": [
        {"status": "Applied", "date": "2024-01-08", "completed": true},
        {"status": "Confirmed", "date": "2024-01-09", "completed": true},
        {"status": "Started", "date": "", "completed": false},
        {"status": "Completed", "date": "", "completed": false},
        {"status": "Paid", "date": "", "completed": false}
      ],
      "unreadMessages": 1,
      "rating": 0,
      "gpsEnabled": false,
      "emergencyContact": "+1-555-0321",
      "cancellationReason": "Weather conditions unsuitable"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredBookings {
    List<Map<String, dynamic>> filtered = _allBookings;

    // Filter by tab
    String tabStatus = '';
    switch (_tabController.index) {
      case 0:
        tabStatus = 'active';
        break;
      case 1:
        tabStatus = 'pending';
        break;
      case 2:
        tabStatus = 'completed';
        break;
      case 3:
        tabStatus = 'cancelled';
        break;
    }

    if (tabStatus.isNotEmpty) {
      filtered = filtered
          .where((booking) =>
              (booking['status'] as String).toLowerCase() == tabStatus)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((booking) =>
              (booking['workerName'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (booking['farmerName'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (booking['jobTitle'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (booking['location'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsModal(booking: booking),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingFilterWidget(
        selectedFilter: _selectedFilter,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _navigateToMessages(String bookingId) {
    // Navigate to messaging screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening messages for booking $bookingId'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleEmergencyContact(String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Emergency Contact',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Call emergency contact: $phoneNumber?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $phoneNumber...'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Call'),
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
        title: Text(
          'Booking Management',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => _handleEmergencyContact('+1-555-EMERGENCY'),
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorLight,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Column(
            children: [
              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search bookings, workers, jobs...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {});
                },
                tabs: [
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Active'),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                            color: AppTheme.successLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_allBookings.where((b) => b['status'] == 'active').length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pending'),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                            color: AppTheme.warningLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_allBookings.where((b) => b['status'] == 'pending').length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Completed'),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_allBookings.where((b) => b['status'] == 'completed').length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Cancelled'),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_allBookings.where((b) => b['status'] == 'cancelled').length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(),
          _buildBookingList(),
          _buildBookingList(),
          _buildBookingList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/job-search-and-filtering');
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'New Booking',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildBookingList() {
    final filteredBookings = _filteredBookings;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'work_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No bookings found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return BookingCardWidget(
            booking: booking,
            onTap: () => _showBookingDetails(booking),
            onMessage: () => _navigateToMessages(booking['id'] as String),
            onEmergencyContact: () =>
                _handleEmergencyContact(booking['emergencyContact'] as String),
          );
        },
      ),
    );
  }
}
