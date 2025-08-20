import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './accuracy_indicator_widget.dart';

class DiseaseDetectionWidget extends StatefulWidget {
  final bool isProcessing;
  final Function(bool) onProcessingChange;

  const DiseaseDetectionWidget({
    super.key,
    required this.isProcessing,
    required this.onProcessingChange,
  });

  @override
  State<DiseaseDetectionWidget> createState() => _DiseaseDetectionWidgetState();
}

class _DiseaseDetectionWidgetState extends State<DiseaseDetectionWidget> {
  String? _selectedImagePath;
  Map<String, dynamic>? _detectionResult;

  void _selectImageFromCamera() async {
    // Simulate camera capture
    widget.onProcessingChange(true);

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _selectedImagePath =
          "https://images.pexels.com/photos/1359807/pexels-photo-1359807.jpeg?auto=compress&cs=tinysrgb&w=400";
    });

    _analyzeImage();
  }

  void _selectImageFromGallery() async {
    // Simulate gallery selection
    widget.onProcessingChange(true);

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _selectedImagePath =
          "https://images.pexels.com/photos/1359807/pexels-photo-1359807.jpeg?auto=compress&cs=tinysrgb&w=400";
    });

    _analyzeImage();
  }

  void _analyzeImage() async {
    if (_selectedImagePath == null) return;

    // Simulate ML analysis
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _detectionResult = {
        'disease': 'Leaf Blight',
        'severity': 'Moderate',
        'confidence': 0.89,
        'affectedArea': '25%',
        'treatment': 'Apply copper-based fungicide every 7 days',
        'preventiveMeasures': [
          'Ensure proper plant spacing',
          'Avoid overhead watering',
          'Remove infected leaves'
        ],
        'organicTreatment': 'Neem oil spray at 2% concentration',
        'timeToTreat': '3-5 days',
        'cropRisk': 'Medium'
      };
    });

    widget.onProcessingChange(false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Selection Section
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'camera_alt',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Plant Image Analysis',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Image Preview
                  if (_selectedImagePath != null)
                    Container(
                      width: double.infinity,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _selectedImagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest,
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'image_not_supported',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'add_photo_alternate',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Select plant image for analysis',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 3.h),

                  // Image Selection Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.isProcessing
                              ? null
                              : _selectImageFromCamera,
                          icon: CustomIconWidget(
                            iconName: 'camera_alt',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          label: Text('Camera'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.isProcessing
                              ? null
                              : _selectImageFromGallery,
                          icon: CustomIconWidget(
                            iconName: 'photo_library',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          label: Text('Gallery'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Processing Indicator
          if (widget.isProcessing)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Analyzing image with AI...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'This may take a few moments',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Results Section
          if (_detectionResult != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'bug_report',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Disease Detection Results',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        AccuracyIndicatorWidget(
                          accuracy: _detectionResult!['confidence'],
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Disease Info
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disease Detected',
                            style: AppTheme.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _detectionResult!['disease'],
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Text(
                                'Severity: ',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                              Text(
                                _detectionResult!['severity'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Affected: ',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                              Text(
                                _detectionResult!['affectedArea'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Treatment
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'healing',
                                color: AppTheme
                                    .lightTheme.colorScheme.onPrimaryContainer,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Recommended Treatment',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _detectionResult!['treatment'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Organic Treatment
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.lightTheme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'eco',
                                color: AppTheme.lightTheme.colorScheme
                                    .onSecondaryContainer,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Organic Treatment',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _detectionResult!['organicTreatment'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Preventive Measures
                    Text(
                      'Preventive Measures',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(_detectionResult!['preventiveMeasures'] as List<String>)
                        .map((measure) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                measure,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 2.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Handle save report
                            },
                            icon: CustomIconWidget(
                              iconName: 'save',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            label: Text('Save Report'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle get help
                            },
                            icon: CustomIconWidget(
                              iconName: 'help',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 16,
                            ),
                            label: Text('Get Help'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
