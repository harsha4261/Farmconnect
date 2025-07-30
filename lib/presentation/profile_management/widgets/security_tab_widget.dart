import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SecurityTabWidget extends StatefulWidget {
  const SecurityTabWidget({Key? key}) : super(key: key);

  @override
  State<SecurityTabWidget> createState() => _SecurityTabWidgetState();
}

class _SecurityTabWidgetState extends State<SecurityTabWidget> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Password Change Section
              _buildPasswordSection(),
              SizedBox(height: 24.sp),

              // Two-Factor Authentication
              _buildTwoFactorSection(),
              SizedBox(height: 24.sp),

              // Biometric Settings
              _buildBiometricSection(),
              SizedBox(height: 24.sp),

              // Active Sessions
              _buildActiveSessionsSection(),
              SizedBox(height: 24.sp),

              // Account Security
              _buildAccountSecuritySection(),
              SizedBox(height: 32.sp),

              // Save Button
              _buildSaveButton(),
            ])));
  }

  Widget _buildPasswordSection() {
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
          Text('Change Password',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildPasswordField(
              controller: _currentPasswordController,
              label: 'Current Password',
              obscureText: _obscureCurrentPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              }),
          SizedBox(height: 16.sp),
          _buildPasswordField(
              controller: _newPasswordController,
              label: 'New Password',
              obscureText: _obscureNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              }),
          SizedBox(height: 16.sp),
          _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              }),
          SizedBox(height: 16.sp),
          _buildPasswordStrengthIndicator(),
          SizedBox(height: 16.sp),
          ElevatedButton(
              onPressed: () {
                // Change password logic
                if (_newPasswordController.text ==
                    _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Password changed successfully')));
                  _clearPasswordFields();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')));
                }
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.sp, horizontal: 24.sp),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp))),
              child: Text('Change Password',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white))),
        ]));
  }

  Widget _buildTwoFactorSection() {
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
          Text('Two-Factor Authentication',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          Row(children: [
            Icon(Icons.security, size: 24.sp),
            SizedBox(width: 12.sp),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Enable Two-Factor Authentication',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4.sp),
                  Text('Add an extra layer of security to your account',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: Colors.grey[600])),
                ])),
            Switch(
                value: _twoFactorEnabled,
                onChanged: (value) {
                  setState(() {
                    _twoFactorEnabled = value;
                  });
                  if (value) {
                    _showTwoFactorSetupDialog();
                  }
                }),
          ]),
          if (_twoFactorEnabled) ...[
            SizedBox(height: 16.sp),
            Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                    color: Colors.green.withAlpha(26),
                    borderRadius: BorderRadius.circular(8.sp)),
                child: Row(children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                  SizedBox(width: 8.sp),
                  Text('Two-factor authentication is enabled',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.w500)),
                ])),
          ],
        ]));
  }

  Widget _buildBiometricSection() {
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
          Text('Biometric Authentication',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          Row(children: [
            Icon(Icons.fingerprint, size: 24.sp),
            SizedBox(width: 12.sp),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Use Biometric Authentication',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4.sp),
                  Text('Use fingerprint or face recognition to log in',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: Colors.grey[600])),
                ])),
            Switch(
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                }),
          ]),
        ]));
  }

  Widget _buildActiveSessionsSection() {
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
          Text('Active Sessions',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildSessionItem('iPhone 13 Pro', 'Current Device', 'Now', true),
          SizedBox(height: 12.sp),
          _buildSessionItem(
              'Chrome Browser', 'Windows PC', '2 hours ago', false),
          SizedBox(height: 16.sp),
          TextButton(
              onPressed: () {
                // End all other sessions
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All other sessions ended')));
              },
              child: Text('End All Other Sessions',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red))),
        ]));
  }

  Widget _buildAccountSecuritySection() {
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
          Text('Account Security',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildSecurityItem(
              'Login History', 'View your recent login activity', Icons.history,
              () {
            // Navigate to login history
          }),
          SizedBox(height: 12.sp),
          _buildSecurityItem('Privacy Settings', 'Control your data privacy',
              Icons.privacy_tip, () {
            // Navigate to privacy settings
          }),
          SizedBox(height: 12.sp),
          _buildSecurityItem('Download My Data', 'Download a copy of your data',
              Icons.download, () {
            // Download data
          }),
          SizedBox(height: 12.sp),
          _buildSecurityItem('Delete Account',
              'Permanently delete your account', Icons.delete_forever, () {
            _showDeleteAccountDialog();
          }, isDestructive: true),
        ]));
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(color: Colors.grey[300]!)),
        child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600]),
                    onPressed: onToggleVisibility),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.all(16.sp))));
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Password Strength',
          style:
              GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500)),
      SizedBox(height: 8.sp),
      LinearProgressIndicator(
          value: 0.7,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
      SizedBox(height: 4.sp),
      Text('Strong',
          style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.orange)),
    ]);
  }

  Widget _buildSessionItem(
      String device, String location, String time, bool isCurrent) {
    return Row(children: [
      Icon(device.contains('iPhone') ? Icons.smartphone : Icons.computer,
          size: 20.sp),
      SizedBox(width: 12.sp),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(device,
            style: GoogleFonts.inter(
                fontSize: 14.sp, fontWeight: FontWeight.w500)),
        Text('$location • $time',
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[600])),
      ])),
      if (isCurrent)
        Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
            decoration: BoxDecoration(
                color: Colors.green.withAlpha(26),
                borderRadius: BorderRadius.circular(4.sp)),
            child: Text('Current',
                style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.green,
                    fontWeight: FontWeight.w500)))
      else
        IconButton(
            icon: Icon(Icons.logout, color: Colors.red, size: 16.sp),
            onPressed: () {
              // End session
            }),
    ]);
  }

  Widget _buildSecurityItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : null),
        title: Text(title,
            style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black)),
        subtitle: Text(subtitle,
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[600])),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
        onTap: onTap);
  }

  Widget _buildSaveButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              // Save security settings
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Security settings saved successfully')));
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.sp),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp))),
            child: Text('Save Security Settings',
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))));
  }

  void _clearPasswordFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Enable Two-Factor Authentication'),
                content: Text(
                    'You will need to set up an authenticator app to complete this process.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to 2FA setup
                      },
                      child: Text('Set Up')),
                ]));
  }

  void _showDeleteAccountDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Delete Account'),
                content: Text(
                    'Are you sure you want to permanently delete your account? This action cannot be undone.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Delete account logic
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Delete')),
                ]));
  }
}
