import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './accuracy_indicator_widget.dart';

class CropYieldPredictionWidget extends StatefulWidget {
  final bool isProcessing;
  final Function(bool) onProcessingChange;

  const CropYieldPredictionWidget({
    super.key,
    required this.isProcessing,
    required this.onProcessingChange,
  });

  @override
  State<CropYieldPredictionWidget> createState() =>
      _CropYieldPredictionWidgetState();
}

class _CropYieldPredictionWidgetState extends State<CropYieldPredictionWidget> {
  String _selectedCrop = 'wheat';
  String _selectedSoilType = 'loamy';
  double _landArea = 1.0;
  Map<String, dynamic>? _predictionResult;

  final List<String> _crops = ['wheat', 'rice', 'cotton', 'corn', 'sugarcane'];
  final List<String> _soilTypes = ['loamy', 'clay', 'sandy', 'silt', 'mixed'];

  void _generatePrediction() async {
    widget.onProcessingChange(true);

    // Simulate ML processing
    await Future.delayed(Duration(seconds: 3));

    // Mock prediction result
    setState(() {
      _predictionResult = {
        'estimatedYield': '2.8 tons/hectare',
        'confidenceLevel': 0.85,
        'recommendation':
            'Optimal conditions for high yield. Consider organic fertilizers.',
        'riskFactors': ['Weather dependency', 'Pest management required'],
        'lastUpdated': DateTime.now(),
        'season': 'Kharif 2024',
        'profitability': 'High',
        'marketDemand': 'Good'
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
          // Input Section
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
                        iconName: 'agriculture',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Crop Information',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Crop Selection
                  Text(
                    'Select Crop',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: CustomIconWidget(
                        iconName: 'grass',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _crops.map((crop) {
                      return DropdownMenuItem(
                        value: crop,
                        child: Text(crop.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCrop = value!;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Soil Type Selection
                  Text(
                    'Soil Type',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  DropdownButtonFormField<String>(
                    value: _selectedSoilType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: CustomIconWidget(
                        iconName: 'terrain',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _soilTypes.map((soil) {
                      return DropdownMenuItem(
                        value: soil,
                        child: Text(soil.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSoilType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Land Area
                  Text(
                    'Land Area (hectares)',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  Slider(
                    value: _landArea,
                    min: 0.5,
                    max: 10.0,
                    divisions: 19,
                    label: '${_landArea.toStringAsFixed(1)} ha',
                    onChanged: (value) {
                      setState(() {
                        _landArea = value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Predict Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          widget.isProcessing ? null : _generatePrediction,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: widget.isProcessing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text('Analyzing...'),
                              ],
                            )
                          : Text('Generate Prediction'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Results Section
          if (_predictionResult != null)
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
                          iconName: 'analytics',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Prediction Results',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        AccuracyIndicatorWidget(
                          accuracy: _predictionResult!['confidenceLevel'],
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Yield Estimate
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'agriculture',
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                            size: 32,
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Yield',
                                style:
                                    AppTheme.lightTheme.textTheme.labelMedium,
                              ),
                              Text(
                                _predictionResult!['estimatedYield'],
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
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

                    // Recommendation
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
                                iconName: 'lightbulb',
                                color: AppTheme.lightTheme.colorScheme
                                    .onSecondaryContainer,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Recommendation',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _predictionResult!['recommendation'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Risk Factors
                    Text(
                      'Risk Factors',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(_predictionResult!['riskFactors'] as List<String>)
                        .map((risk) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'warning',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                risk,
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
                              // Handle share
                            },
                            icon: CustomIconWidget(
                              iconName: 'share',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 16,
                            ),
                            label: Text('Share'),
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
