import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingFilterWidget extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const BookingFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<BookingFilterWidget> createState() => _BookingFilterWidgetState();
}

class _BookingFilterWidgetState extends State<BookingFilterWidget> {
  late String _selectedFilter;
  String _selectedJobType = 'all';
  String _selectedPaymentStatus = 'all';
  DateTimeRange? _selectedDateRange;

  final List<Map<String, String>> _filterOptions = [
    {'value': 'all', 'label': 'All Bookings', 'icon': 'list'},
    {'value': 'today', 'label': 'Today', 'icon': 'today'},
    {'value': 'this_week', 'label': 'This Week', 'icon': 'date_range'},
    {'value': 'this_month', 'label': 'This Month', 'icon': 'calendar_month'},
    {'value': 'urgent', 'label': 'Urgent Jobs', 'icon': 'priority_high'},
    {'value': 'high_pay', 'label': 'High Payment', 'icon': 'attach_money'},
  ];

  final List<Map<String, String>> _jobTypes = [
    {'value': 'all', 'label': 'All Types'},
    {'value': 'harvesting', 'label': 'Harvesting'},
    {'value': 'planting', 'label': 'Planting'},
    {'value': 'irrigation', 'label': 'Irrigation'},
    {'value': 'maintenance', 'label': 'Maintenance'},
    {'value': 'pest_control', 'label': 'Pest Control'},
  ];

  final List<Map<String, String>> _paymentStatuses = [
    {'value': 'all', 'label': 'All Statuses'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'paid', 'label': 'Paid'},
    {'value': 'refunded', 'label': 'Refunded'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedFilter = 'all';
      _selectedJobType = 'all';
      _selectedPaymentStatus = 'all';
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onFilterChanged(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filter Bookings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Quick Filters
          Text(
            'Quick Filters',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _filterOptions.map((option) {
              final isSelected = _selectedFilter == option['value'];
              return FilterChip(
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? option['value']! : 'all';
                  });
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: option['icon']!,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(option['label']!),
                  ],
                ),
                selectedColor: AppTheme.lightTheme.colorScheme.primary,
                checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Job Type Filter
          Text(
            'Job Type',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              border:
                  Border.all(color: AppTheme.lightTheme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedJobType,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedJobType = value!;
                  });
                },
                items: _jobTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']!),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Payment Status Filter
          Text(
            'Payment Status',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              border:
                  Border.all(color: AppTheme.lightTheme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPaymentStatus,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentStatus = value!;
                  });
                },
                items: _paymentStatuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status['value'],
                    child: Text(status['label']!),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Date Range Filter
          Text(
            'Date Range',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          InkWell(
            onTap: _selectDateRange,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppTheme.lightTheme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'date_range',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _selectedDateRange != null
                          ? '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}'
                          : 'Select date range',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: _selectedDateRange != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (_selectedDateRange != null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDateRange = null;
                        });
                      },
                      child: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
