import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/crop_yield_prediction_widget.dart';
import './widgets/disease_detection_widget.dart';
import './widgets/farm_location_header_widget.dart';
import './widgets/price_trends_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/weather_forecast_widget.dart';

class SmartFarmTools extends StatefulWidget {
  const SmartFarmTools({super.key});

  @override
  State<SmartFarmTools> createState() => _SmartFarmToolsState();
}

class _SmartFarmToolsState extends State<SmartFarmTools>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isProcessing = false;
  String _selectedTool = 'yield_prediction';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleToolSelection(String toolType) {
    setState(() {
      _selectedTool = toolType;
    });
  }

  void _handleProcessing(bool isProcessing) {
    setState(() {
      _isProcessing = isProcessing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        title: Text(
          'Smart Farm Tools',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('AI Tools Help'),
                  content: Text(
                      'These tools use machine learning to provide agricultural insights. Ensure good internet connection for best results.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'agriculture',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              text: 'Yield Prediction',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'bug_report',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Disease Detection',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'wb_cloudy',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Weather Forecast',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Price Trends',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Farm Location Header
          FarmLocationHeaderWidget(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Crop Yield Prediction
                CropYieldPredictionWidget(
                  isProcessing: _isProcessing,
                  onProcessingChange: _handleProcessing,
                ),

                // Disease Detection
                DiseaseDetectionWidget(
                  isProcessing: _isProcessing,
                  onProcessingChange: _handleProcessing,
                ),

                // Weather Forecast
                WeatherForecastWidget(),

                // Price Trends
                PriceTrendsWidget(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 0.5,
            ),
          ),
        ),
        child: QuickActionsWidget(
          selectedTool: _selectedTool,
          onToolSelected: _handleToolSelection,
        ),
      ),
    );
  }
}
