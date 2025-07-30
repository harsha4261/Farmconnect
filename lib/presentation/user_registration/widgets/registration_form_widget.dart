import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationFormWidget extends StatefulWidget {
  final String formType;
  final String selectedRole;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const RegistrationFormWidget({
    Key? key,
    required this.formType,
    required this.selectedRole,
    required this.initialData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = _getFormFields();
    for (String field in fields) {
      _controllers[field] = TextEditingController(
          text: widget.initialData[field]?.toString() ?? '');
    }
  }

  List<String> _getFormFields() {
    switch (widget.formType) {
      case 'personal':
        return ['fullName', 'email', 'password', 'confirmPassword'];
      case 'professional':
        return widget.selectedRole == 'farmer'
            ? ['farmName', 'farmSize', 'cropTypes', 'location']
            : ['skills', 'experience', 'transportation', 'location'];
      case 'verification':
        return ['phoneNumber', 'verificationCode'];
      default:
        return [];
    }
  }

  void _updateFormData() {
    final data = <String, dynamic>{};
    for (String field in _getFormFields()) {
      data[field] = _controllers[field]?.text ?? '';
    }
    widget.onDataChanged(data);
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      _isVerifying = true;
    });

    // Simulate sending verification code
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Verification code sent via SMS',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildFormTitle(),
              SizedBox(height: 24.h),
              ..._buildFormFields(),
            ])));
  }

  Widget _buildFormTitle() {
    String title;
    String subtitle;

    switch (widget.formType) {
      case 'personal':
        title = 'Personal Information';
        subtitle = 'Tell us about yourself';
        break;
      case 'professional':
        title = widget.selectedRole == 'farmer'
            ? 'Farm Details'
            : 'Work Experience';
        subtitle = widget.selectedRole == 'farmer'
            ? 'Share information about your farm'
            : 'Tell us about your skills and experience';
        break;
      case 'verification':
        title = 'Phone Verification';
        subtitle = 'Verify your phone number for security';
        break;
      default:
        title = 'Information';
        subtitle = 'Please provide required details';
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface)),
      SizedBox(height: 4.h),
      Text(subtitle,
          style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(179))),
    ]);
  }

  List<Widget> _buildFormFields() {
    switch (widget.formType) {
      case 'personal':
        return _buildPersonalFields();
      case 'professional':
        return widget.selectedRole == 'farmer'
            ? _buildFarmerFields()
            : _buildWorkerFields();
      case 'verification':
        return _buildVerificationFields();
      default:
        return [];
    }
  }

  List<Widget> _buildPersonalFields() {
    return [
      _buildTextField(
          controller: _controllers['fullName']!,
          label: 'Full Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your full name';
            }
            return null;
          }),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['email']!,
          label: 'Email Address (Optional)',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['password']!,
          label: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter a password';
            }
            if (value!.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          }),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['confirmPassword']!,
          label: 'Confirm Password',
          icon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (value != _controllers['password']!.text) {
              return 'Passwords do not match';
            }
            return null;
          }),
    ];
  }

  List<Widget> _buildFarmerFields() {
    return [
      _buildTextField(
          controller: _controllers['farmName']!,
          label: 'Farm Name',
          icon: Icons.agriculture_outlined,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your farm name';
            }
            return null;
          }),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['farmSize']!,
          label: 'Farm Size (acres)',
          icon: Icons.straighten_outlined,
          keyboardType: TextInputType.number),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['cropTypes']!,
          label: 'Crop Types',
          icon: Icons.grass_outlined,
          maxLines: 3,
          hintText: 'e.g., Wheat, Corn, Soybeans'),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['location']!,
          label: 'Farm Location',
          icon: Icons.location_on_outlined,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your farm location';
            }
            return null;
          }),
    ];
  }

  List<Widget> _buildWorkerFields() {
    return [
      _buildTextField(
          controller: _controllers['skills']!,
          label: 'Skills & Expertise',
          icon: Icons.build_outlined,
          maxLines: 3,
          hintText: 'e.g., Harvesting, Planting, Equipment Operation',
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please describe your skills';
            }
            return null;
          }),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['experience']!,
          label: 'Years of Experience',
          icon: Icons.work_outline,
          keyboardType: TextInputType.number),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['transportation']!,
          label: 'Transportation',
          icon: Icons.directions_car_outlined,
          hintText: 'e.g., Own vehicle, Public transport, Bicycle'),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['location']!,
          label: 'Current Location',
          icon: Icons.location_on_outlined,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your location';
            }
            return null;
          }),
    ];
  }

  List<Widget> _buildVerificationFields() {
    return [
      _buildTextField(
          controller: _controllers['phoneNumber']!,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your phone number';
            }
            return null;
          }),
      SizedBox(height: 16.h),
      Row(children: [
        Expanded(
            child: OutlinedButton(
                onPressed: _isVerifying ? null : _sendVerificationCode,
                child: _isVerifying
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary)))
                    : Text('Send Code',
                        style:
                            GoogleFonts.inter(fontWeight: FontWeight.w500)))),
      ]),
      SizedBox(height: 16.h),
      _buildTextField(
          controller: _controllers['verificationCode']!,
          label: 'Verification Code',
          icon: Icons.sms_outlined,
          keyboardType: TextInputType.number,
          hintText: 'Enter 6-digit code'),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: (value) => _updateFormData(),
        decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2))));
  }
}
