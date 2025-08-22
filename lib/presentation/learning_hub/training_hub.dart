import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrainingHubScreen extends StatelessWidget {
  const TrainingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tutorials = const [
      {'title': 'Pesticide Safety Basics', 'duration': '4:20'},
      {'title': 'Tractor Operation 101', 'duration': '6:05'},
      {'title': 'Irrigation Setup Tips', 'duration': '3:45'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Training Hub')),
      body: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemCount: tutorials.length,
        separatorBuilder: (_, __) => SizedBox(height: 1.h),
        itemBuilder: (context, index) {
          final t = tutorials[index];
          return ListTile(
            leading: const Icon(Icons.play_circle_fill),
            title: Text(t['title']!),
            subtitle: Text('Duration: ${t['duration']}'),
            tileColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video playback coming soon')),
              );
            },
          );
        },
      ),
    );
  }
}


