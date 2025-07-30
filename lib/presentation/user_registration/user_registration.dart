import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/role_selection_widget.dart';
import './widgets/terms_acceptance_widget.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String _selectedRole = '';
  bool _isLoading = false;

  final Map<String, dynamic> _formData = {
    'role': '',
    'fullName': '',
    'phoneNumber': '',
    'email': '',
    'password': '',
    'profilePhoto': null,
    'location': '',
    'farmerDetails': {},
    'workerDetails': {},
    'termsAccepted': false,
  };

  final List<String> _steps = [
    'Role Selection',
    'Personal Info',
    'Professional Details',
    'Verification',
    'Terms & Conditions',
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
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

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
      _formData['role'] = role;
    });
  }

  void _onFormDataChanged(Map<String, dynamic> data) {
    setState(() {
      _formData.addAll(data);
    });
  }

  Future<void> _completeRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration successful! Welcome to FarmConnect.',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to appropriate dashboard
        final route = _selectedRole == 'farmer'
            ? AppRoutes.farmerDashboard
            : AppRoutes.workerDashboard;

        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed. Please try again.',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Progress indicator
          ProgressIndicatorWidget(
            steps: _steps,
            currentStep: _currentStep,
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Role Selection
                RoleSelectionWidget(
                  selectedRole: _selectedRole,
                  onRoleSelected: _onRoleSelected,
                ),

                // Step 2: Personal Info
                RegistrationFormWidget(
                  formType: 'personal',
                  selectedRole: _selectedRole,
                  initialData: _formData,
                  onDataChanged: _onFormDataChanged,
                ),

                // Step 3: Professional Details
                RegistrationFormWidget(
                  formType: 'professional',
                  selectedRole: _selectedRole,
                  initialData: _formData,
                  onDataChanged: _onFormDataChanged,
                ),

                // Step 4: Verification
                RegistrationFormWidget(
                  formType: 'verification',
                  selectedRole: _selectedRole,
                  initialData: _formData,
                  onDataChanged: _onFormDataChanged,
                ),

                // Step 5: Terms & Conditions
                TermsAcceptanceWidget(
                  onAccepted: (accepted) {
                    setState(() {
                      _formData['termsAccepted'] = accepted;
                    });
                  },
                ),
              ],
            ),
          ),

          // Bottom navigation
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Back button
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _previousStep,
                      child: Text(
                        'Back',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                if (_currentStep > 0) SizedBox(width: 16.w),

                // Next/Complete button
                Expanded(
                  flex: _currentStep > 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_currentStep == _steps.length - 1) {
                              if (_formData['termsAccepted'] == true) {
                                _completeRegistration();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please accept the terms and conditions.',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } else {
                              _nextStep();
                            }
                          },
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            _currentStep == _steps.length - 1
                                ? 'Complete Registration'
                                : 'Continue',
                            style: GoogleFonts.inter(
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
