import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'english', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'hindi', 'name': 'हिंदी', 'flag': '🇮🇳'},
      {'code': 'telugu', 'name': 'తెలుగు', 'flag': '🇮🇳'},
      {'code': 'kannada', 'name': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
      {'code': 'marathi', 'name': 'मराठी', 'flag': '🇮🇳'},
    ];

    return PopupMenuButton<String>(
      onSelected: onLanguageChanged,
      itemBuilder: (context) {
        return languages.map((language) {
          return PopupMenuItem(
            value: language['code'],
            child: Row(
              children: [
                Text(
                  language['flag']!,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 2.w),
                Text(
                  language['name']!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                if (selectedLanguage == language['code']) ...[
                  Spacer(),
                  CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                ],
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languages.firstWhere(
                  (lang) => lang['code'] == selectedLanguage)['flag']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'arrow_drop_down',
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
