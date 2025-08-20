import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Function(List<String>) onFiltersApplied;
  final List<String> currentFilters;

  const FilterModalWidget({
    Key? key,
    required this.onFiltersApplied,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late List<String> _selectedFilters;
  double _distanceRadius = 10.0;
  RangeValues _payRange = const RangeValues(300, 700);
  String _selectedJobType = 'All';
  String _selectedExperience = 'All';
  bool _toolsProvided = false;
  bool _accommodationAvailable = false;

  final List<String> _jobTypes = [
    'All',
    'Harvesting',
    'Planting',
    'Irrigation',
    'Fertilizing',
    'Weeding'
  ];

  final List<String> _experienceLevels = [
    'All',
    'Beginner',
    'Intermediate',
    'Expert'
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Filter Jobs',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Clear All'),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3)),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance filter
                  _buildFilterSection(
                    title: 'Distance Radius',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_distanceRadius.round()} km',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Slider(
                          value: _distanceRadius,
                          min: 1.0,
                          max: 50.0,
                          divisions: 49,
                          onChanged: (value) {
                            setState(() {
                              _distanceRadius = value;
                            });
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Pay range filter
                  _buildFilterSection(
                    title: 'Pay Range (per day)',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${_payRange.start.round()} - ₹${_payRange.end.round()}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        RangeSlider(
                          values: _payRange,
                          min: 200.0,
                          max: 1000.0,
                          divisions: 40,
                          onChanged: (values) {
                            setState(() {
                              _payRange = values;
                            });
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Job type filter
                  _buildFilterSection(
                    title: 'Job Type',
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _jobTypes.map((type) {
                        final isSelected = _selectedJobType == type;
                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedJobType = type;
                            });
                            HapticFeedback.selectionClick();
                          },
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.surface,
                          selectedColor: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          checkmarkColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          labelStyle: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Experience level filter
                  _buildFilterSection(
                    title: 'Experience Required',
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _experienceLevels.map((level) {
                        final isSelected = _selectedExperience == level;
                        return FilterChip(
                          label: Text(level),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedExperience = level;
                            });
                            HapticFeedback.selectionClick();
                          },
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.surface,
                          selectedColor: AppTheme
                              .lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.2),
                          checkmarkColor:
                              AppTheme.lightTheme.colorScheme.secondary,
                          labelStyle: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Additional filters
                  _buildFilterSection(
                    title: 'Additional Requirements',
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Tools Provided'),
                          subtitle: const Text('Farm provides necessary tools'),
                          value: _toolsProvided,
                          onChanged: (value) {
                            setState(() {
                              _toolsProvided = value;
                            });
                            HapticFeedback.selectionClick();
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: const Text('Accommodation Available'),
                          subtitle: const Text('On-site housing provided'),
                          value: _accommodationAvailable,
                          onChanged: (value) {
                            setState(() {
                              _accommodationAvailable = value;
                            });
                            HapticFeedback.selectionClick();
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        child,
        SizedBox(height: 3.h),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _distanceRadius = 10.0;
      _payRange = const RangeValues(300, 700);
      _selectedJobType = 'All';
      _selectedExperience = 'All';
      _toolsProvided = false;
      _accommodationAvailable = false;
    });
    HapticFeedback.lightImpact();
  }

  void _applyFilters() {
    final List<String> filters = [];

    if (_distanceRadius != 10.0) {
      filters.add('Within ${_distanceRadius.round()}km');
    }

    if (_payRange.start != 300.0 || _payRange.end != 700.0) {
      filters.add('₹${_payRange.start.round()}-${_payRange.end.round()}/day');
    }

    if (_selectedJobType != 'All') {
      filters.add(_selectedJobType);
    }

    if (_selectedExperience != 'All') {
      filters.add('${_selectedExperience} level');
    }

    if (_toolsProvided) {
      filters.add('Tools provided');
    }

    if (_accommodationAvailable) {
      filters.add('Accommodation');
    }

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
    HapticFeedback.mediumImpact();
  }
}
