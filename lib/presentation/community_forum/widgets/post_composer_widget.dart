import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostComposerWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPost;

  const PostComposerWidget({
    super.key,
    required this.onPost,
  });

  @override
  State<PostComposerWidget> createState() => _PostComposerWidgetState();
}

class _PostComposerWidgetState extends State<PostComposerWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedCategory = 'tips';
  bool _isPosting = false;

  final List<String> _categories = [
    'tips',
    'market',
    'scheme',
    'general',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handlePost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    // Simulate posting
    await Future.delayed(Duration(seconds: 2));

    final newPost = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'authorName': 'Your Name',
      'authorPhoto':
          'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400',
      'timestamp': 'Just now',
      'location': _locationController.text.isEmpty
          ? 'Unknown Location'
          : _locationController.text,
      'category': _selectedCategory,
      'title': _titleController.text,
      'content': _contentController.text,
      'imageUrl': null,
      'likes': 0,
      'comments': 0,
      'isLiked': false,
      'isBookmarked': false,
      'hashtags': [],
    };

    widget.onPost(newPost);

    setState(() {
      _isPosting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            Row(
              children: [
                CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Create New Post',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Category Selection
            Text(
              'Category',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: CustomIconWidget(
                  iconName: 'category',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),

            SizedBox(height: 2.h),

            // Title Input
            Text(
              'Title',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter post title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: CustomIconWidget(
                  iconName: 'title',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Content Input
            Text(
              'Content',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your thoughts, tips, or questions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
            ),

            SizedBox(height: 2.h),

            // Location Input
            Text(
              'Location (Optional)',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter your location...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPosting
                        ? null
                        : () {
                            // Handle photo attachment
                          },
                    icon: CustomIconWidget(
                      iconName: 'photo_camera',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Add Photo'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isPosting ? null : _handlePost,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: _isPosting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text('Post'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
