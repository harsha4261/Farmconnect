import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class JobRequirementsWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final Function(String, dynamic) onDataChanged;

  const JobRequirementsWidget({
    Key? key,
    required this.jobData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<JobRequirementsWidget> createState() => _JobRequirementsWidgetState();
}

class _JobRequirementsWidgetState extends State<JobRequirementsWidget> {
  final List<String> _experienceLevels = [
    'Entry Level',
    'Some Experience',
    'Experienced',
    'Expert',
  ];

  final List<String> _physicalDemands = [
    'Heavy Lifting',
    'Standing for Long Periods',
    'Outdoor Work',
    'Repetitive Tasks',
    'Manual Labor',
    'Operating Machinery',
  ];

  final List<String> _equipmentOptions = [
    'Tractor',
    'Harvester',
    'Irrigation Systems',
    'Hand Tools',
    'Spraying Equipment',
    'Pruning Tools',
  ];

  final List<String> _certificationOptions = [
    'Pesticide Application',
    'Heavy Equipment Operation',
    'First Aid/CPR',
    'Organic Farming',
    'Food Safety',
    'Machinery Safety',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience Level Required',
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
                value: widget.jobData['experienceLevel']?.isNotEmpty == true
                    ? widget.jobData['experienceLevel']
                    : null,
                hint: const Text('Select experience level'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isExpanded: true,
                items: _experienceLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) =>
                    widget.onDataChanged('experienceLevel', value),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Physical Demands',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _physicalDemands.map((demand) {
              final isSelected =
                  (widget.jobData['physicalDemands'] ?? []).contains(demand);
              return FilterChip(
                label: Text(demand),
                selected: isSelected,
                onSelected: (selected) {
                  List<String> currentDemands = List<String>.from(
                      widget.jobData['physicalDemands'] ?? []);
                  if (selected) {
                    currentDemands.add(demand);
                  } else {
                    currentDemands.remove(demand);
                  }
                  widget.onDataChanged('physicalDemands', currentDemands);
                },
                selectedColor: AppTheme.primaryLight.withAlpha(51),
                labelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: isSelected
                      ? AppTheme.primaryLight
                      : AppTheme.textSecondaryLight,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Equipment Familiarity',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _equipmentOptions.map((equipment) {
              final isSelected = (widget.jobData['equipmentFamiliarity'] ?? [])
                  .contains(equipment);
              return FilterChip(
                label: Text(equipment),
                selected: isSelected,
                onSelected: (selected) {
                  List<String> currentEquipment = List<String>.from(
                      widget.jobData['equipmentFamiliarity'] ?? []);
                  if (selected) {
                    currentEquipment.add(equipment);
                  } else {
                    currentEquipment.remove(equipment);
                  }
                  widget.onDataChanged(
                      'equipmentFamiliarity', currentEquipment);
                },
                selectedColor: AppTheme.secondaryLight.withAlpha(51),
                labelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: isSelected
                      ? AppTheme.secondaryLight
                      : AppTheme.textSecondaryLight,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Required Certifications',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _certificationOptions.map((certification) {
              final isSelected = (widget.jobData['certifications'] ?? [])
                  .contains(certification);
              return FilterChip(
                label: Text(certification),
                selected: isSelected,
                onSelected: (selected) {
                  List<String> currentCertifications =
                      List<String>.from(widget.jobData['certifications'] ?? []);
                  if (selected) {
                    currentCertifications.add(certification);
                  } else {
                    currentCertifications.remove(certification);
                  }
                  widget.onDataChanged('certifications', currentCertifications);
                },
                selectedColor: AppTheme.accentLight.withAlpha(51),
                labelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: isSelected
                      ? AppTheme.accentLight
                      : AppTheme.textSecondaryLight,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.warningLight.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.warningLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: Be specific about requirements to attract qualified workers',
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
