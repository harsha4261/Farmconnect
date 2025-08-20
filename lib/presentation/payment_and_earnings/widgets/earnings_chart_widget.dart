import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EarningsChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String period;

  const EarningsChartWidget({
    super.key,
    required this.data,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lightTheme.colorScheme.outline)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Earnings Trend',
                style: AppTheme.lightTheme.textTheme.titleMedium),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(period.toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold))),
          ]),
          SizedBox(height: 3.h),
          Expanded(
              child: data.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          CustomIconWidget(
                              iconName: 'bar_chart',
                              color: AppTheme.lightTheme.colorScheme.outline,
                              size: 48),
                          SizedBox(height: 2.h),
                          Text('No data available',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant)),
                        ]))
                  : BarChart(BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(),
                      barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                              tooltipRoundedRadius: 8,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                    '₹${rod.toY.toStringAsFixed(0)}',
                                    AppTheme.lightTheme.textTheme.bodySmall!
                                        .copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onInverseSurface));
                              })),
                      titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < data.length) {
                                      final item = data[value.toInt()];
                                      String label = '';

                                      switch (period) {
                                        case 'daily':
                                          label = (item["day"] as String)
                                              .substring(0, 3);
                                          break;
                                        case 'weekly':
                                          label = 'W${value.toInt() + 1}';
                                          break;
                                        case 'monthly':
                                          label = (item["month"] as String)
                                              .substring(0, 3);
                                          break;
                                      }

                                      return Padding(
                                          padding: EdgeInsets.only(top: 1.h),
                                          child: Text(label,
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall));
                                    }
                                    return SizedBox();
                                  },
                                  reservedSize: 4.h)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 12.w,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0) return SizedBox();
                                    return Text(
                                        '₹${(value / 1000).toStringAsFixed(0)}k',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall);
                                  }))),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                  width: 1),
                              left: BorderSide(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                  width: 1))),
                      barGroups: _buildBarGroups(),
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: _getMaxY() / 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                                strokeWidth: 1);
                          })))),
        ]));
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final amount = item["amount"] as double;

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: amount,
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 6.w,
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.7),
                ])),
      ]);
    }).toList();
  }

  double _getMaxY() {
    if (data.isEmpty) return 1000;

    final maxAmount = data
        .map((item) => item["amount"] as double)
        .reduce((a, b) => a > b ? a : b);
    return (maxAmount * 1.2).ceilToDouble();
  }
}
