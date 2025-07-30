import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ForumSearchWidget extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return AppTheme.lightTheme;
  }

  @override
  String get searchFieldLabel => 'Search posts, topics, or users...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 24,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Mock search results
    final results = [
      {
        'type': 'post',
        'title': 'Best wheat varieties for Karnataka',
        'author': 'Ravi Patel',
        'timestamp': '2 hours ago',
        'category': 'tips',
      },
      {
        'type': 'post',
        'title': 'Current rice prices in Punjab',
        'author': 'Sunita Devi',
        'timestamp': '5 hours ago',
        'category': 'market',
      },
      {
        'type': 'user',
        'name': 'Amit Singh',
        'location': 'Haryana',
        'posts': 45,
      },
    ];

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        if (result['type'] == 'post') {
          return ListTile(
            leading: CustomIconWidget(
              iconName: 'article',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            title: Text(result['title'] as String),
            subtitle: Text('by ${result['author']} • ${result['timestamp']}'),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (result['category'] as String).toUpperCase(),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            onTap: () {
              close(context, result['title'] as String);
            },
          );
        } else {
          return ListTile(
            leading: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
            title: Text(result['name'] as String),
            subtitle: Text('${result['location']} • ${result['posts']} posts'),
            onTap: () {
              close(context, result['name'] as String);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'wheat farming tips',
      'rice market prices',
      'organic fertilizers',
      'pest control methods',
      'government schemes',
      'weather forecast',
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
