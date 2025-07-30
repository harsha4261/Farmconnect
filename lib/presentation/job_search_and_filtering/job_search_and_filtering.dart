import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/job_map_widget.dart';
import './widgets/sort_options_widget.dart';

class JobSearchAndFiltering extends StatefulWidget {
  const JobSearchAndFiltering({Key? key}) : super(key: key);

  @override
  State<JobSearchAndFiltering> createState() => _JobSearchAndFilteringState();
}

class _JobSearchAndFilteringState extends State<JobSearchAndFiltering>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isMapView = false;
  bool _isLoading = false;
  String _selectedSort = 'Distance';
  List<String> _activeFilters = ['Within 10km', 'Harvesting'];
  List<Map<String, dynamic>> _filteredJobs = [];

  // Mock job data
  final List<Map<String, dynamic>> _allJobs = [
    {
      "id": 1,
      "title": "Wheat Harvesting - Urgent",
      "farmName": "Green Valley Farm",
      "location": "Punjab, India",
      "distance": "2.5 km",
      "payRate": "₹500/day",
      "duration": "3 days",
      "urgency": "urgent",
      "cropType": "Wheat",
      "experienceRequired": "Beginner",
      "toolsProvided": true,
      "accommodationAvailable": false,
      "farmImage":
          "https://images.pexels.com/photos/2132227/pexels-photo-2132227.jpeg",
      "startDate": "2024-01-15",
      "description":
          "Need experienced workers for wheat harvesting. Early morning start required.",
      "latitude": 30.7333,
      "longitude": 76.7794,
      "isBookmarked": false,
      "farmRating": 4.5,
      "totalWorkers": 8,
      "appliedWorkers": 3
    },
    {
      "id": 2,
      "title": "Rice Planting Season",
      "farmName": "Sunrise Agriculture",
      "location": "Haryana, India",
      "distance": "5.2 km",
      "payRate": "₹450/day",
      "duration": "5 days",
      "urgency": "normal",
      "cropType": "Rice",
      "experienceRequired": "Intermediate",
      "toolsProvided": true,
      "accommodationAvailable": true,
      "farmImage":
          "https://images.pexels.com/photos/1595104/pexels-photo-1595104.jpeg",
      "startDate": "2024-01-20",
      "description":
          "Rice planting work with accommodation provided. Meals included.",
      "latitude": 29.0588,
      "longitude": 76.0856,
      "isBookmarked": true,
      "farmRating": 4.2,
      "totalWorkers": 12,
      "appliedWorkers": 7
    },
    {
      "id": 3,
      "title": "Vegetable Harvesting",
      "farmName": "Fresh Fields Co.",
      "location": "Uttar Pradesh, India",
      "distance": "8.1 km",
      "payRate": "₹400/day",
      "duration": "2 days",
      "urgency": "normal",
      "cropType": "Vegetables",
      "experienceRequired": "Beginner",
      "toolsProvided": false,
      "accommodationAvailable": false,
      "farmImage":
          "https://images.pexels.com/photos/1459339/pexels-photo-1459339.jpeg",
      "startDate": "2024-01-18",
      "description": "Harvesting tomatoes and peppers. Bring your own tools.",
      "latitude": 28.6139,
      "longitude": 77.2090,
      "isBookmarked": false,
      "farmRating": 4.0,
      "totalWorkers": 6,
      "appliedWorkers": 2
    },
    {
      "id": 4,
      "title": "Irrigation System Setup",
      "farmName": "Modern Agri Solutions",
      "location": "Rajasthan, India",
      "distance": "12.3 km",
      "payRate": "₹600/day",
      "duration": "7 days",
      "urgency": "priority",
      "cropType": "Mixed",
      "experienceRequired": "Expert",
      "toolsProvided": true,
      "accommodationAvailable": true,
      "farmImage":
          "https://images.pexels.com/photos/1595108/pexels-photo-1595108.jpeg",
      "startDate": "2024-01-22",
      "description":
          "Setting up drip irrigation system. Technical expertise required.",
      "latitude": 26.9124,
      "longitude": 75.7873,
      "isBookmarked": false,
      "farmRating": 4.8,
      "totalWorkers": 4,
      "appliedWorkers": 1
    },
    {
      "id": 5,
      "title": "Fruit Picking - Apple Orchard",
      "farmName": "Hill Station Orchards",
      "location": "Himachal Pradesh, India",
      "distance": "15.7 km",
      "payRate": "₹550/day",
      "duration": "10 days",
      "urgency": "normal",
      "cropType": "Fruits",
      "experienceRequired": "Intermediate",
      "toolsProvided": true,
      "accommodationAvailable": true,
      "farmImage":
          "https://images.pexels.com/photos/1459331/pexels-photo-1459331.jpeg",
      "startDate": "2024-01-25",
      "description":
          "Apple picking season in hill station. Beautiful location with accommodation.",
      "latitude": 31.1048,
      "longitude": 77.1734,
      "isBookmarked": true,
      "farmRating": 4.6,
      "totalWorkers": 15,
      "appliedWorkers": 8
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredJobs = List.from(_allJobs);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterJobs();
  }

  void _filterJobs() {
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = searchTerm.isEmpty ||
            (job["title"] as String).toLowerCase().contains(searchTerm) ||
            (job["farmName"] as String).toLowerCase().contains(searchTerm) ||
            (job["location"] as String).toLowerCase().contains(searchTerm) ||
            (job["cropType"] as String).toLowerCase().contains(searchTerm);

        return matchesSearch;
      }).toList();

      _sortJobs();
    });
  }

  void _sortJobs() {
    switch (_selectedSort) {
      case 'Distance':
        _filteredJobs.sort((a, b) {
          final aDistance = double.parse(
              (a["distance"] as String).replaceAll(RegExp(r'[^0-9.]'), ''));
          final bDistance = double.parse(
              (b["distance"] as String).replaceAll(RegExp(r'[^0-9.]'), ''));
          return aDistance.compareTo(bDistance);
        });
        break;
      case 'Pay Rate':
        _filteredJobs.sort((a, b) {
          final aRate = int.parse(
              (a["payRate"] as String).replaceAll(RegExp(r'[^0-9]'), ''));
          final bRate = int.parse(
              (b["payRate"] as String).replaceAll(RegExp(r'[^0-9]'), ''));
          return bRate.compareTo(aRate);
        });
        break;
      case 'Start Date':
        _filteredJobs.sort((a, b) =>
            (a["startDate"] as String).compareTo(b["startDate"] as String));
        break;
      case 'Duration':
        _filteredJobs.sort((a, b) {
          final aDuration = int.parse(
              (a["duration"] as String).replaceAll(RegExp(r'[^0-9]'), ''));
          final bDuration = int.parse(
              (b["duration"] as String).replaceAll(RegExp(r'[^0-9]'), ''));
          return aDuration.compareTo(bDuration);
        });
        break;
    }
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
  }

  void _toggleBookmark(int jobId) {
    setState(() {
      final jobIndex = _filteredJobs.indexWhere((job) => job["id"] == jobId);
      if (jobIndex != -1) {
        _filteredJobs[jobIndex]["isBookmarked"] =
            !(_filteredJobs[jobIndex]["isBookmarked"] as bool);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
      _filterJobs();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _filterJobs();
          });
        },
        currentFilters: _activeFilters,
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsWidget(
        currentSort: _selectedSort,
        onSortSelected: (sort) {
          setState(() {
            _selectedSort = sort;
            _sortJobs();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs, farms, locations...',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterJobs();
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        // Voice search functionality
                        HapticFeedback.lightImpact();
                      },
                      icon: CustomIconWidget(
                        iconName: 'mic',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: _isMapView
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isMapView = false;
                    });
                    HapticFeedback.selectionClick();
                  },
                  icon: CustomIconWidget(
                    iconName: 'list',
                    color: !_isMapView
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
                Container(
                  width: 1,
                  height: 3.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isMapView = true;
                    });
                    HapticFeedback.selectionClick();
                  },
                  icon: CustomIconWidget(
                    iconName: 'map',
                    color: _isMapView
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips section
          if (_activeFilters.isNotEmpty)
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _activeFilters.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 2.w),
                      itemBuilder: (context, index) {
                        return FilterChipWidget(
                          label: _activeFilters[index],
                          onRemove: () => _removeFilter(_activeFilters[index]),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: _showFilterModal,
                    icon: CustomIconWidget(
                      iconName: 'filter_list',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

          // Main content area
          Expanded(
            child: _isMapView
                ? JobMapWidget(
                    jobs: _filteredJobs,
                    onJobTap: (job) {
                      _showJobBottomSheet(job);
                    },
                  )
                : RefreshIndicator(
                    onRefresh: _refreshJobs,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          )
                        : _filteredJobs.isEmpty
                            ? _buildEmptyState()
                            : ListView.separated(
                                controller: _scrollController,
                                padding: EdgeInsets.all(4.w),
                                itemCount: _filteredJobs.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 2.h),
                                itemBuilder: (context, index) {
                                  return JobCardWidget(
                                    job: _filteredJobs[index],
                                    onBookmarkTap: () => _toggleBookmark(
                                        _filteredJobs[index]["id"] as int),
                                    onApplyTap: () =>
                                        _applyToJob(_filteredJobs[index]),
                                    onShareTap: () =>
                                        _shareJob(_filteredJobs[index]),
                                    onLongPress: () =>
                                        _showQuickActions(_filteredJobs[index]),
                                  );
                                },
                              ),
                  ),
          ),
        ],
      ),
      floatingActionButton: !_isMapView
          ? FloatingActionButton(
              onPressed: _showSortOptions,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'sort',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No jobs found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
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
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _activeFilters.clear();
                _searchController.clear();
                _filterJobs();
              });
            },
            child: const Text('Clear all filters'),
          ),
        ],
      ),
    );
  }

  void _showJobBottomSheet(Map<String, dynamic> job) {
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
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: JobCardWidget(
                job: job,
                isExpanded: true,
                onBookmarkTap: () => _toggleBookmark(job["id"] as int),
                onApplyTap: () => _applyToJob(job),
                onShareTap: () => _shareJob(job),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyToJob(Map<String, dynamic> job) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied to ${job["title"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
    HapticFeedback.mediumImpact();
  }

  void _shareJob(Map<String, dynamic> job) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${job["title"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'thumb_down',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Not Interested'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Save for Later'),
              onTap: () {
                Navigator.pop(context);
                _toggleBookmark(job["id"] as int);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'directions',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Get Directions'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
