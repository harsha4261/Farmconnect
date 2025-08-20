import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/job_basics_widget.dart';
import './widgets/job_compensation_widget.dart';
import './widgets/job_photos_widget.dart';
import './widgets/job_preview_widget.dart';
import './widgets/job_requirements_widget.dart';
import './widgets/job_scheduling_widget.dart';

class JobPosting extends StatefulWidget {
  const JobPosting({Key? key}) : super(key: key);

  @override
  State<JobPosting> createState() => _JobPostingState();
}

class _JobPostingState extends State<JobPosting> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  final Map<String, dynamic> _jobData = {
    'title': '',
    'description': '',
    'category': '',
    'isCustomCategory': false,
    'isSeasonal': false,
    'location': '',
    'latitude': 0.0,
    'longitude': 0.0,
    'radius': 10,
    'experienceLevel': '',
    'physicalDemands': [],
    'equipmentFamiliarity': [],
    'certifications': [],
    'hourlyRate': 0.0,
    'pieceWorkRate': 0.0,
    'bonusStructure': '',
    'paymentTiming': '',
    'photos': [],
    'scheduleType': '',
    'startDate': null,
    'endDate': null,
    'isRecurring': false,
    'weatherContingency': false,
    'emergencyContact': '',
    'accommodation': false,
  };

  final List<String> _stepTitles = [
    'Job Basics',
    'Requirements',
    'Compensation',
    'Scheduling',
    'Photos',
    'Preview'
  ];

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateJobData(String key, dynamic value) {
    setState(() {
      _jobData[key] = value;
    });
  }

  void _autoSave() async {
    // Auto-save functionality for poor connectivity
    // Implementation would save draft to local storage
  }

  void _publishJob() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job posted successfully!'),
            backgroundColor: AppTheme.successLight,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting job: $e'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(_stepTitles.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: AppTheme.onPrimaryLight,
                          size: 16,
                        )
                      : Center(
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? AppTheme.onPrimaryLight
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        ),
                ),
                if (index < _stepTitles.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted
                          ? AppTheme.primaryLight
                          : AppTheme.dividerLight,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Post a Job',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _autoSave,
            child: Text(
              'Save Draft',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryLight,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                JobBasicsWidget(
                  jobData: _jobData,
                  onDataChanged: _updateJobData,
                ),
                JobRequirementsWidget(
                  jobData: _jobData,
                  onDataChanged: _updateJobData,
                ),
                JobCompensationWidget(
                  jobData: _jobData,
                  onDataChanged: _updateJobData,
                ),
                JobSchedulingWidget(
                  jobData: _jobData,
                  onDataChanged: _updateJobData,
                ),
                JobPhotosWidget(
                  jobData: _jobData,
                  onDataChanged: _updateJobData,
                ),
                JobPreviewWidget(
                  jobData: _jobData,
                  onEdit: (step) {
                    setState(() {
                      _currentStep = step;
                    });
                    _pageController.animateToPage(
                      step,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceLight,
              border: Border(
                top: BorderSide(color: AppTheme.dividerLight),
              ),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.primaryLight),
                      ),
                      child: Text(
                        'Previous',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _currentStep == _stepTitles.length - 1
                            ? _publishJob
                            : _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryLight,
                      foregroundColor: AppTheme.onPrimaryLight,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.onPrimaryLight,
                              ),
                            ),
                          )
                        : Text(
                            _currentStep == _stepTitles.length - 1
                                ? 'Publish Job'
                                : 'Next',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
