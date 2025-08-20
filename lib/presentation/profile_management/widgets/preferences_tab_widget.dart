import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PreferencesTabWidget extends StatefulWidget {
  const PreferencesTabWidget({Key? key}) : super(key: key);

  @override
  State<PreferencesTabWidget> createState() => _PreferencesTabWidgetState();
}

class _PreferencesTabWidgetState extends State<PreferencesTabWidget> {
  bool _profileVisibility = true;
  bool _locationSharing = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _jobAlerts = true;
  bool _bookingConfirmations = true;
  bool _paymentNotifications = true;
  bool _emergencyAlerts = true;

  String _jobAlertRadius = '25 miles';
  String _workingHours = '8 AM - 6 PM';
  String _preferredContact = 'Phone';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Privacy Settings
              _buildPrivacySection(),
              SizedBox(height: 24.sp),

              // Notification Settings
              _buildNotificationSection(),
              SizedBox(height: 24.sp),

              // Job Preferences
              _buildJobPreferencesSection(),
              SizedBox(height: 24.sp),

              // Communication Preferences
              _buildCommunicationSection(),
              SizedBox(height: 32.sp),

              // Save Button
              _buildSaveButton(),
            ])));
  }

  Widget _buildPrivacySection() {
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
          Text('Privacy Settings',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildSwitchTile(
              'Profile Visibility',
              'Make your profile visible to other users',
              _profileVisibility, (value) {
            setState(() {
              _profileVisibility = value;
            });
          }),
          _buildSwitchTile(
              'Location Sharing',
              'Allow sharing your location for job matching',
              _locationSharing, (value) {
            setState(() {
              _locationSharing = value;
            });
          }),
        ]));
  }

  Widget _buildNotificationSection() {
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
          Text('Notification Settings',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildSwitchTile('Email Notifications',
              'Receive notifications via email', _emailNotifications, (value) {
            setState(() {
              _emailNotifications = value;
            });
          }),
          _buildSwitchTile(
              'Push Notifications',
              'Receive push notifications on your device',
              _pushNotifications, (value) {
            setState(() {
              _pushNotifications = value;
            });
          }),
          SizedBox(height: 16.sp),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 16.sp),
          Text('Notification Types',
              style: GoogleFonts.inter(
                  fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.sp),
          _buildSwitchTile(
              'Job Alerts',
              'New job opportunities matching your skills',
              _jobAlerts, (value) {
            setState(() {
              _jobAlerts = value;
            });
          }),
          _buildSwitchTile(
              'Booking Confirmations',
              'Job booking confirmations and updates',
              _bookingConfirmations, (value) {
            setState(() {
              _bookingConfirmations = value;
            });
          }),
          _buildSwitchTile('Payment Notifications',
              'Payment and earnings updates', _paymentNotifications, (value) {
            setState(() {
              _paymentNotifications = value;
            });
          }),
          _buildSwitchTile(
              'Emergency Alerts',
              'Urgent job requests and emergency notifications',
              _emergencyAlerts, (value) {
            setState(() {
              _emergencyAlerts = value;
            });
          }),
        ]));
  }

  Widget _buildJobPreferencesSection() {
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
          Text('Job Preferences',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildDropdownField(
              'Job Alert Radius',
              _jobAlertRadius,
              ['10 miles', '25 miles', '50 miles', '100 miles'],
              Icons.location_on, (value) {
            setState(() {
              _jobAlertRadius = value!;
            });
          }),
          SizedBox(height: 16.sp),
          _buildDropdownField(
              'Preferred Working Hours',
              _workingHours,
              ['8 AM - 6 PM', '6 AM - 4 PM', '9 AM - 7 PM', 'Flexible'],
              Icons.schedule, (value) {
            setState(() {
              _workingHours = value!;
            });
          }),
        ]));
  }

  Widget _buildCommunicationSection() {
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
          Text('Communication Preferences',
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 16.sp),
          _buildDropdownField(
              'Preferred Contact Method',
              _preferredContact,
              ['Phone', 'Email', 'In-App Message', 'SMS'],
              Icons.contact_phone, (value) {
            setState(() {
              _preferredContact = value!;
            });
          }),
        ]));
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value,
      void Function(bool) onChanged) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.sp),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 14.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 2.sp),
                Text(subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: Colors.grey[600])),
              ])),
          Switch(value: value, onChanged: onChanged),
        ]));
  }

  Widget _buildDropdownField(String label, String value, List<String> options,
      IconData icon, void Function(String?) onChanged) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(color: Colors.grey[300]!)),
        child: DropdownButtonFormField<String>(
            initialValue: value,
            decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.all(16.sp)),
            items: options
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: onChanged));
  }

  Widget _buildSaveButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              // Save preferences
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Preferences saved successfully')));
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.sp),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp))),
            child: Text('Save Preferences',
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))));
  }
}
