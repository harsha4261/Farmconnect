import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PersonalInfoTabWidget extends StatefulWidget {
  final String userRole;

  const PersonalInfoTabWidget({
    Key? key,
    required this.userRole,
  }) : super(key: key);

  @override
  State<PersonalInfoTabWidget> createState() => _PersonalInfoTabWidgetState();
}

class _PersonalInfoTabWidgetState extends State<PersonalInfoTabWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _addressController =
      TextEditingController(text: '123 Farm Road, Rural County, State 12345');
  final _emergencyContactController =
      TextEditingController(text: 'Jane Doe - +1 (555) 987-6543');
  String _selectedLanguage = 'English';

  String _fullName = 'John Doe';
  String _phoneNumber = '+1 (555) 123-4567';
  String _email = 'john.doe@example.com';
  String _location = '123 Farm Road, Rural County, State 12345';
  String _dateOfBirth = '01/01/1980';
  String _idNumber = '123456789';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 16),
          _buildProfilePhoto(),
          const SizedBox(height: 24),
          _buildPersonalForm(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryLight,
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.surfaceLight,
        ),
        child: Icon(Icons.person, size: 60, color: AppTheme.primaryLight),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _savePersonalInfo() {
    // Save personal info implementation
  }

  Widget _buildDocumentItem({
    required String title,
    required String status,
    required bool isVerified,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            Text(status),
            Icon(
              isVerified ? Icons.check_circle : Icons.pending,
              color: isVerified ? Colors.green : Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerLight),
      ),
      child: Column(
        children: [
          _buildTextField(
            label: 'Full Name',
            value: _fullName,
            onChanged: (value) => setState(() => _fullName = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Phone Number',
            value: _phoneNumber,
            onChanged: (value) => setState(() => _phoneNumber = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Email',
            value: _email,
            onChanged: (value) => setState(() => _email = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Location',
            value: _location,
            onChanged: (value) => setState(() => _location = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Date of Birth',
            value: _dateOfBirth,
            onChanged: (value) => setState(() => _dateOfBirth = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'ID Number',
            value: _idNumber,
            onChanged: (value) => setState(() => _idNumber = value),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _savePersonalInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              foregroundColor: AppTheme.onPrimaryLight,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentVerification() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user,
                size: 20,
                color: AppTheme.primaryLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Document Verification',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Government ID',
            status: 'Verified',
            isVerified: true,
          ),
          const SizedBox(height: 12),
          _buildDocumentItem(
            title: 'Proof of Address',
            status: 'Pending',
            isVerified: false,
          ),
          const SizedBox(height: 12),
          _buildDocumentItem(
            title: 'Agricultural Certification',
            status: 'Not Uploaded',
            isVerified: false,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              // Handle document upload
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryLight),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Upload Documents',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
