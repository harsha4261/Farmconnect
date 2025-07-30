import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class JobBasicsWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final Function(String, dynamic) onDataChanged;

  const JobBasicsWidget({
    Key? key,
    required this.jobData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<JobBasicsWidget> createState() => _JobBasicsWidgetState();
}

class _JobBasicsWidgetState extends State<JobBasicsWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customCategoryController = TextEditingController();
  final _locationController = TextEditingController();

  final List<String> _predefinedCategories = [
    'Crop Harvesting',
    'Planting & Seeding',
    'Pruning & Maintenance',
    'Irrigation Management',
    'Pest Control',
    'Livestock Care',
    'Equipment Operation',
    'General Farm Labor',
    'Seasonal Work',
    'Custom'
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.jobData['title'] ?? '';
    _descriptionController.text = widget.jobData['description'] ?? '';
    _locationController.text = widget.jobData['location'] ?? '';
    _customCategoryController.text = widget.jobData['customCategory'] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _customCategoryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _getCurrentLocation() async {
    // GPS location functionality
    widget.onDataChanged('location', 'Current Location');
    widget.onDataChanged('latitude', 37.7749);
    widget.onDataChanged('longitude', -122.4194);
    _locationController.text = 'Current Location';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Title',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter job title',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => widget.onDataChanged('title', value),
          ),
          const SizedBox(height: 24),
          Text(
            'Job Description',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Describe the job responsibilities and requirements',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onChanged: (value) => widget.onDataChanged('description', value),
          ),
          const SizedBox(height: 24),
          Text(
            'Job Category',
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
                value: widget.jobData['category']?.isNotEmpty == true
                    ? widget.jobData['category']
                    : null,
                hint: const Text('Select job category'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isExpanded: true,
                items: _predefinedCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  widget.onDataChanged('category', value);
                  widget.onDataChanged('isCustomCategory', value == 'Custom');
                },
              ),
            ),
          ),
          if (widget.jobData['isCustomCategory'] == true) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _customCategoryController,
              decoration: const InputDecoration(
                hintText: 'Enter custom category',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  widget.onDataChanged('customCategory', value),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: widget.jobData['isSeasonal'] ?? false,
                onChanged: (value) => widget.onDataChanged('isSeasonal', value),
              ),
              const SizedBox(width: 8),
              Text(
                'Seasonal Work',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Location',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter job location',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _getCurrentLocation,
              ),
            ),
            onChanged: (value) => widget.onDataChanged('location', value),
          ),
          const SizedBox(height: 24),
          Text(
            'Job Visibility Radius',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slider(
                value: (widget.jobData['radius'] ?? 10).toDouble(),
                min: 1,
                max: 50,
                divisions: 49,
                label: '${widget.jobData['radius'] ?? 10} km',
                onChanged: (value) =>
                    widget.onDataChanged('radius', value.round()),
              ),
              Text(
                'Workers within ${widget.jobData['radius'] ?? 10} km will see this job',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
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
                    'Tip: Clear, specific job titles get more applications',
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
