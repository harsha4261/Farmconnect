import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherForecastWidget extends StatefulWidget {
  const WeatherForecastWidget({super.key});

  @override
  State<WeatherForecastWidget> createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  final List<Map<String, dynamic>> _weatherData = [
    {
      'day': 'Today',
      'date': 'Jul 15',
      'icon': 'wb_sunny',
      'temp': '32°C',
      'condition': 'Sunny',
      'humidity': '65%',
      'rainfall': '0mm',
      'advisory': 'Good day for irrigation',
      'windSpeed': '12 km/h'
    },
    {
      'day': 'Tomorrow',
      'date': 'Jul 16',
      'icon': 'wb_cloudy',
      'temp': '28°C',
      'condition': 'Cloudy',
      'humidity': '75%',
      'rainfall': '5mm',
      'advisory': 'Light rain expected',
      'windSpeed': '8 km/h'
    },
    {
      'day': 'Wednesday',
      'date': 'Jul 17',
      'icon': 'thunderstorm',
      'temp': '25°C',
      'condition': 'Rainy',
      'humidity': '85%',
      'rainfall': '25mm',
      'advisory': 'Avoid field work',
      'windSpeed': '20 km/h'
    },
    {
      'day': 'Thursday',
      'date': 'Jul 18',
      'icon': 'wb_sunny',
      'temp': '30°C',
      'condition': 'Sunny',
      'humidity': '60%',
      'rainfall': '0mm',
      'advisory': 'Perfect for harvesting',
      'windSpeed': '15 km/h'
    },
    {
      'day': 'Friday',
      'date': 'Jul 19',
      'icon': 'wb_cloudy',
      'temp': '29°C',
      'condition': 'Partly Cloudy',
      'humidity': '70%',
      'rainfall': '2mm',
      'advisory': 'Good planting conditions',
      'windSpeed': '10 km/h'
    },
    {
      'day': 'Saturday',
      'date': 'Jul 20',
      'icon': 'wb_sunny',
      'temp': '33°C',
      'condition': 'Sunny',
      'humidity': '55%',
      'rainfall': '0mm',
      'advisory': 'Apply fertilizers',
      'windSpeed': '18 km/h'
    },
    {
      'day': 'Sunday',
      'date': 'Jul 21',
      'icon': 'wb_cloudy',
      'temp': '27°C',
      'condition': 'Overcast',
      'humidity': '80%',
      'rainfall': '8mm',
      'advisory': 'Monitor pest activity',
      'windSpeed': '6 km/h'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Weather
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
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Current Location - Bangalore',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: _weatherData[0]['icon'],
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 64,
                      ),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _weatherData[0]['temp'],
                            style: AppTheme.lightTheme.textTheme.headlineLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _weatherData[0]['condition'],
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherDetail('Humidity',
                          _weatherData[0]['humidity'], 'water_drop'),
                      _buildWeatherDetail(
                          'Rainfall', _weatherData[0]['rainfall'], 'umbrella'),
                      _buildWeatherDetail(
                          'Wind', _weatherData[0]['windSpeed'], 'air'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Agricultural Advisory
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
                        iconName: 'info',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Agricultural Advisory',
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
                          'Today\'s Recommendation',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _weatherData[0]['advisory'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Handle irrigation reminder
                          },
                          icon: CustomIconWidget(
                            iconName: 'water_drop',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 16,
                          ),
                          label: Text('Set Irrigation'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle spray reminder
                          },
                          icon: CustomIconWidget(
                            iconName: 'spray',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          label: Text('Plan Spray'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // 7-Day Forecast
          Text(
            '7-Day Forecast',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _weatherData.length,
            itemBuilder: (context, index) {
              final weather = _weatherData[index];
              return Card(
                elevation: 1,
                margin: EdgeInsets.only(bottom: 2.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather['day'],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weather['date'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: weather['icon'],
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 32,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  weather['temp'],
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  weather['condition'],
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              weather['advisory'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            weather['rainfall'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weather['humidity'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
