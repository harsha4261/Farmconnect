import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class JobCompensationWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final Function(String, dynamic) onDataChanged;

  const JobCompensationWidget({
    Key? key,
    required this.jobData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<JobCompensationWidget> createState() => _JobCompensationWidgetState();
}

class _JobCompensationWidgetState extends State<JobCompensationWidget> {
  final _hourlyRateController = TextEditingController();
  final _pieceWorkController = TextEditingController();
  final _bonusController = TextEditingController();

  final List<String> _paymentTimingOptions = [
    'Daily',
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'End of Job',
  ];

  @override
  void initState() {
    super.initState();
    _hourlyRateController.text = widget.jobData['hourlyRate']?.toString() ?? '';
    _pieceWorkController.text =
        widget.jobData['pieceWorkRate']?.toString() ?? '';
    _bonusController.text = widget.jobData['bonusStructure'] ?? '';
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _pieceWorkController.dispose();
    _bonusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly Rate',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _hourlyRateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '0.00',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final rate = double.tryParse(value) ?? 0.0;
              widget.onDataChanged('hourlyRate', rate);
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Piece Work Rate (Optional)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pieceWorkController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g., per basket, per tree, per row',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final rate = double.tryParse(value) ?? 0.0;
              widget.onDataChanged('pieceWorkRate', rate);
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Bonus Structure (Optional)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bonusController,
            decoration: const InputDecoration(
              hintText: 'e.g., \$50 bonus for completing the job early',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            onChanged: (value) => widget.onDataChanged('bonusStructure', value),
          ),
          const SizedBox(height: 24),
          Text(
            'Payment Timing',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.jobData['paymentTiming']?.isNotEmpty == true
                    ? widget.jobData['paymentTiming']
                    : null,
                hint: const Text('Select payment timing'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isExpanded: true,
                items: _paymentTimingOptions.map((timing) {
                  return DropdownMenuItem(
                    value: timing,
                    child: Text(timing),
                  );
                }).toList(),
                onChanged: (value) =>
                    widget.onDataChanged('paymentTiming', value),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.successLight.withAlpha(77)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppTheme.successLight,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Local Market Rate Suggestions',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Average rates in your area:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• General Farm Labor: \$15-20/hour\n• Skilled Operation: \$20-25/hour\n• Specialized Tasks: \$25-30/hour',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: Competitive pay attracts better workers and faster applications',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
