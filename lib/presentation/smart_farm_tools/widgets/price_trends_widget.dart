import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriceTrendsWidget extends StatefulWidget {
  const PriceTrendsWidget({super.key});

  @override
  State<PriceTrendsWidget> createState() => _PriceTrendsWidgetState();
}

class _PriceTrendsWidgetState extends State<PriceTrendsWidget> {
  String _selectedCrop = 'wheat';
  String _selectedTimeframe = '7days';

  final Map<String, List<FlSpot>> _priceData = {
    'wheat': [
      FlSpot(0, 2050),
      FlSpot(1, 2080),
      FlSpot(2, 2040),
      FlSpot(3, 2100),
      FlSpot(4, 2120),
      FlSpot(5, 2090),
      FlSpot(6, 2110),
    ],
    'rice': [
      FlSpot(0, 3200),
      FlSpot(1, 3250),
      FlSpot(2, 3180),
      FlSpot(3, 3300),
      FlSpot(4, 3350),
      FlSpot(5, 3280),
      FlSpot(6, 3320),
    ],
    'cotton': [
      FlSpot(0, 5500),
      FlSpot(1, 5650),
      FlSpot(2, 5400),
      FlSpot(3, 5750),
      FlSpot(4, 5800),
      FlSpot(5, 5600),
      FlSpot(6, 5850),
    ],
  };

  final Map<String, Map<String, dynamic>> _cropInfo = {
    'wheat': {
      'currentPrice': '₹2,110',
      'change': '+2.9%',
      'changeColor': Colors.green,
      'recommendation': 'Good time to sell',
      'marketDemand': 'High',
      'bestPrice': '₹2,120',
      'worstPrice': '₹2,040',
    },
    'rice': {
      'currentPrice': '₹3,320',
      'change': '+3.75%',
      'changeColor': Colors.green,
      'recommendation': 'Hold for better prices',
      'marketDemand': 'Moderate',
      'bestPrice': '₹3,350',
      'worstPrice': '₹3,180',
    },
    'cotton': {
      'currentPrice': '₹5,850',
      'change': '+6.36%',
      'changeColor': Colors.green,
      'recommendation': 'Excellent selling opportunity',
      'marketDemand': 'Very High',
      'bestPrice': '₹5,800',
      'worstPrice': '₹5,400',
    },
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crop Selection
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
                        iconName: 'trending_up',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Market Price Trends',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Crop Selection Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    decoration: InputDecoration(
                      labelText: 'Select Crop',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: CustomIconWidget(
                        iconName: 'agriculture',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _priceData.keys.map((crop) {
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
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Current Price Info
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                    AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Price',
                            style: AppTheme.lightTheme.textTheme.labelMedium,
                          ),
                          Text(
                            _cropInfo[_selectedCrop]!['currentPrice'],
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: _cropInfo[_selectedCrop]!['changeColor'],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _cropInfo[_selectedCrop]!['change'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceDetail(
                          'Best Price',
                          _cropInfo[_selectedCrop]!['bestPrice'],
                          'trending_up'),
                      _buildPriceDetail(
                          'Worst Price',
                          _cropInfo[_selectedCrop]!['worstPrice'],
                          'trending_down'),
                      _buildPriceDetail(
                          'Demand',
                          _cropInfo[_selectedCrop]!['marketDemand'],
                          'bar_chart'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Price Chart
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price Chart (7 Days)',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'show_chart',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Per Quintal',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Chart
                  Container(
                    height: 30.h,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun'
                                ];
                                return Text(
                                  days[value.toInt()],
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _priceData[_selectedCrop]!,
                            isCurved: true,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withAlpha(26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Recommendation
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
                        iconName: 'lightbulb',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Trading Recommendation',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Market Analysis',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _cropInfo[_selectedCrop]!['recommendation'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Handle price alert
                          },
                          icon: CustomIconWidget(
                            iconName: 'notifications',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 16,
                          ),
                          label: Text('Set Price Alert'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle find buyers
                          },
                          icon: CustomIconWidget(
                            iconName: 'people',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          label: Text('Find Buyers'),
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

  Widget _buildPriceDetail(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
