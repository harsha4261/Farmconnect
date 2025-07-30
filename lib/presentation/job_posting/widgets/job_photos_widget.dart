import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class JobPhotosWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final Function(String, dynamic) onDataChanged;

  const JobPhotosWidget({
    Key? key,
    required this.jobData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<JobPhotosWidget> createState() => _JobPhotosWidgetState();
}

class _JobPhotosWidgetState extends State<JobPhotosWidget> {
  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=500',
    'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=500',
    'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=500',
  ];

  void _addPhoto() {
    // Simulate adding a photo
    List<String> currentPhotos =
        List<String>.from(widget.jobData['photos'] ?? []);
    if (currentPhotos.length < 5) {
      currentPhotos
          .add(_sampleImages[currentPhotos.length % _sampleImages.length]);
      widget.onDataChanged('photos', currentPhotos);
    }
  }

  void _removePhoto(int index) {
    List<String> currentPhotos =
        List<String>.from(widget.jobData['photos'] ?? []);
    currentPhotos.removeAt(index);
    widget.onDataChanged('photos', currentPhotos);
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.jobData['photos'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Photos',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add photos of the work area, equipment, and accommodation (if provided)',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              ...photos.asMap().entries.map((entry) {
                final index = entry.key;
                final photo = entry.value;

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.dividerLight.withAlpha(77),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photo,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.dividerLight.withAlpha(77),
                              child: const Icon(
                                Icons.image,
                                size: 40,
                                color: AppTheme.textSecondaryLight,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
              if (photos.length < 5)
                GestureDetector(
                  onTap: _addPhoto,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryLight,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: AppTheme.primaryLight,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Photo',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.photo_camera,
                      color: AppTheme.primaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Photo Tips',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Take clear photos in good lighting\n• Show the work area and equipment\n• Include accommodation if provided\n• Avoid photos with personal information\n• Maximum 5 photos allowed',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (photos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.dividerLight),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.image,
                    size: 48,
                    color: AppTheme.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Photos help workers understand the job better',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jobs with photos get 3x more applications',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
