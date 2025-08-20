import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CountryCodePickerWidget extends StatelessWidget {
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;

  const CountryCodePickerWidget({
    super.key,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  final List<Map<String, String>> _countryCodes = const [
    {'code': '+91', 'country': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'country': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'UK', 'flag': '🇬🇧'},
    {'code': '+86', 'country': 'China', 'flag': '🇨🇳'},
    {'code': '+81', 'country': 'Japan', 'flag': '🇯🇵'},
    {'code': '+49', 'country': 'Germany', 'flag': '🇩🇪'},
    {'code': '+33', 'country': 'France', 'flag': '🇫🇷'},
    {'code': '+61', 'country': 'Australia', 'flag': '🇦🇺'},
    {'code': '+55', 'country': 'Brazil', 'flag': '🇧🇷'},
    {'code': '+7', 'country': 'Russia', 'flag': '🇷🇺'},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCountry = _countryCodes.firstWhere(
      (country) => country['code'] == selectedCountryCode,
      orElse: () => _countryCodes.first,
    );

    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCountry['flag']!,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(width: 1.w),
            Text(
              selectedCountryCode,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        height: 50.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Title
            Text(
              'Select Country Code',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),

            // Country list
            Expanded(
              child: ListView.separated(
                itemCount: _countryCodes.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final country = _countryCodes[index];
                  final isSelected = country['code'] == selectedCountryCode;

                  return ListTile(
                    leading: Text(
                      country['flag']!,
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    title: Text(
                      country['country']!,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      country['code']!,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    onTap: () {
                      onCountryCodeChanged(country['code']!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
