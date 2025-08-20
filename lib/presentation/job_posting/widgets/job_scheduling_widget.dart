import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class JobSchedulingWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final Function(String, dynamic) onDataChanged;

  const JobSchedulingWidget({
    Key? key,
    required this.jobData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<JobSchedulingWidget> createState() => _JobSchedulingWidgetState();
}

class _JobSchedulingWidgetState extends State<JobSchedulingWidget> {
  final _emergencyContactController = TextEditingController();

  final List<String> _scheduleTypes = [
    'Single Day',
    'Multiple Days',
    'Recurring Weekly',
    'Recurring Monthly',
    'Seasonal',
  ];

  @override
  void initState() {
    super.initState();
    _emergencyContactController.text = widget.jobData['emergencyContact'] ?? '';
  }

  @override
  void dispose() {
    _emergencyContactController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      widget.onDataChanged(type, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Type',
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
                value: widget.jobData['scheduleType']?.isNotEmpty == true
                    ? widget.jobData['scheduleType']
                    : null,
                hint: const Text('Select schedule type'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isExpanded: true,
                items: _scheduleTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) =>
                    widget.onDataChanged('scheduleType', value),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start Date',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context, 'startDate'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.dividerLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.jobData['startDate'] != null
                        ? '${widget.jobData['startDate'].day}/${widget.jobData['startDate'].month}/${widget.jobData['startDate'].year}'
                        : 'Select start date',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: widget.jobData['startDate'] != null
                          ? AppTheme.textPrimaryLight
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'End Date (Optional)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context, 'endDate'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.dividerLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.jobData['endDate'] != null
                        ? '${widget.jobData['endDate'].day}/${widget.jobData['endDate'].month}/${widget.jobData['endDate'].year}'
                        : 'Select end date',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: widget.jobData['endDate'] != null
                          ? AppTheme.textPrimaryLight
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: widget.jobData['weatherContingency'] ?? false,
                onChanged: (value) =>
                    widget.onDataChanged('weatherContingency', value),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Weather Contingency - Job may be postponed due to weather conditions',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: widget.jobData['accommodation'] ?? false,
                onChanged: (value) =>
                    widget.onDataChanged('accommodation', value),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Accommodation provided',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Emergency Contact',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emergencyContactController,
            decoration: const InputDecoration(
              hintText: 'Enter emergency contact details',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) =>
                widget.onDataChanged('emergencyContact', value),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.errorLight.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.errorLight.withAlpha(77)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppTheme.errorLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Safety First: Emergency contact is required for remote work locations',
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
