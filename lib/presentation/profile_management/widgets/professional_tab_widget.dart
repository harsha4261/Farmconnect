import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProfessionalTabWidget extends StatefulWidget {
  final String userRole;

  const ProfessionalTabWidget({
    Key? key,
    required this.userRole,
  }) : super(key: key);

  @override
  State<ProfessionalTabWidget> createState() => _ProfessionalTabWidgetState();
}

class _ProfessionalTabWidgetState extends State<ProfessionalTabWidget> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController =
      TextEditingController(text: 'Green Valley Farm');
  final _businessAddressController =
      TextEditingController(text: '456 Farm Lane, Agricultural District');
  final _experienceController = TextEditingController(text: '5');
  final _specialtiesController =
      TextEditingController(text: 'Crop Harvesting, Livestock Management');
  final _certificationsController =
      TextEditingController(text: 'Organic Farming Certification');
  final _equipmentController =
      TextEditingController(text: 'Tractor, Harvester, Irrigation System');

  List<String> _selectedSkills = ['Crop Management', 'Livestock Care'];
  bool _backgroundCheckCompleted = true;
  bool _insuranceActive = true;
  bool _availableForEmergency = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _experienceController.dispose();
    _specialtiesController.dispose();
    _certificationsController.dispose();
    _equipmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role-specific content
                      if (widget.userRole == 'farmer') ..._buildFarmerContent(),
                      if (widget.userRole == 'worker') ..._buildWorkerContent(),

                      SizedBox(height: 24.sp),

                      // Verification Section
                      _buildVerificationSection(),
                      SizedBox(height: 24.sp),

                      // Skills and Certifications
                      _buildSkillsSection(),
                      SizedBox(height: 32.sp),

                      // Save Button
                      _buildSaveButton(),
                    ]))));
  }

  List<Widget> _buildFarmerContent() {
    return [
      _buildSectionHeader('Farm Information'),
      SizedBox(height: 16.sp),
      _buildTextField(
          controller: _businessNameController,
          label: 'Farm/Business Name',
          icon: Icons.business,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Business name is required';
            return null;
          }),
      SizedBox(height: 16.sp),
      _buildTextField(
          controller: _businessAddressController,
          label: 'Farm Address',
          icon: Icons.location_on,
          maxLines: 2,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Farm address is required';
            return null;
          }),
      SizedBox(height: 16.sp),
      _buildTextField(
          controller: _equipmentController,
          label: 'Available Equipment',
          icon: Icons.agriculture,
          maxLines: 3),
      SizedBox(height: 16.sp),
      _buildInsuranceCard(),
    ];
  }

  List<Widget> _buildWorkerContent() {
    return [
      _buildSectionHeader('Professional Experience'),
      SizedBox(height: 16.sp),
      _buildTextField(
          controller: _experienceController,
          label: 'Years of Experience',
          icon: Icons.work,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Experience is required';
            return null;
          }),
      SizedBox(height: 16.sp),
      _buildTextField(
          controller: _specialtiesController,
          label: 'Specialties',
          icon: Icons.stars,
          maxLines: 2),
      SizedBox(height: 16.sp),
      _buildAvailabilityCard(),
    ];
  }

  Widget _buildVerificationSection() {
    return Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Verification Status',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildVerificationItem(
              'Background Check', _backgroundCheckCompleted, Icons.security),
          SizedBox(height: 12.sp),
          _buildVerificationItem(
              'Insurance Coverage', _insuranceActive, Icons.shield),
          SizedBox(height: 12.sp),
          _buildVerificationItem(
              'Identity Verification', true, Icons.verified_user),
        ]));
  }

  Widget _buildVerificationItem(String title, bool isVerified, IconData icon) {
    return Row(children: [
      Icon(icon, color: isVerified ? Colors.green : Colors.orange, size: 20.sp),
      SizedBox(width: 12.sp),
      Expanded(
          child: Text(title,
              style: GoogleFonts.inter(
                  fontSize: 14.sp, fontWeight: FontWeight.w500))),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
          decoration: BoxDecoration(
              color: isVerified
                  ? Colors.green.withAlpha(26)
                  : Colors.orange.withAlpha(26),
              borderRadius: BorderRadius.circular(8.sp)),
          child: Text(isVerified ? 'Verified' : 'Pending',
              style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isVerified ? Colors.green : Colors.orange))),
    ]);
  }

  Widget _buildSkillsSection() {
    return Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Skills & Certifications',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildTextField(
              controller: _certificationsController,
              label: 'Certifications',
              icon: Icons.help_outline,
              maxLines: 2),
          SizedBox(height: 16.sp),
          Text('Selected Skills',
              style: GoogleFonts.inter(
                  fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.sp),
          Wrap(
              spacing: 8.sp,
              runSpacing: 8.sp,
              children: _selectedSkills
                  .map((skill) => Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _selectedSkills.remove(skill);
                        });
                      }))
                  .toList()),
        ]));
  }

  Widget _buildInsuranceCard() {
    return Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Insurance Information',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          SwitchListTile(
              title: Text('Insurance Active'),
              value: _insuranceActive,
              onChanged: (value) {
                setState(() {
                  _insuranceActive = value;
                });
              }),
        ]));
  }

  Widget _buildAvailabilityCard() {
    return Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Availability Settings',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          SwitchListTile(
              title: Text('Available for Emergency Jobs'),
              value: _availableForEmergency,
              onChanged: (value) {
                setState(() {
                  _availableForEmergency = value;
                });
              }),
        ]));
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16.sp))));
  }

  Widget _buildSaveButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save professional information
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Professional information saved successfully')));
              }
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.sp),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp))),
            child: Text('Save Changes',
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))));
  }
}
