import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAcceptanceWidget extends StatefulWidget {
  final Function(bool) onAccepted;

  const TermsAcceptanceWidget({
    Key? key,
    required this.onAccepted,
  }) : super(key: key);

  @override
  State<TermsAcceptanceWidget> createState() => _TermsAcceptanceWidgetState();
}

class _TermsAcceptanceWidgetState extends State<TermsAcceptanceWidget> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedLabor = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Title
          Text('Terms & Conditions',
              style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface)),

          SizedBox(height: 4.h),

          Text(
              'Please review and accept our terms to complete your registration.',
              style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color:
                      Theme.of(context).colorScheme.onSurface.withAlpha(179))),

          SizedBox(height: 24.h),

          // Terms sections
          _buildTermsSection(
              title: 'Terms of Service',
              description:
                  'Our platform terms, user responsibilities, and service agreement.',
              icon: Icons.description_outlined,
              isAccepted: _acceptedTerms,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value;
                  _updateAcceptanceStatus();
                });
              }),

          SizedBox(height: 16.h),

          _buildTermsSection(
              title: 'Privacy Policy',
              description:
                  'How we collect, use, and protect your personal information.',
              icon: Icons.privacy_tip_outlined,
              isAccepted: _acceptedPrivacy,
              onChanged: (value) {
                setState(() {
                  _acceptedPrivacy = value;
                  _updateAcceptanceStatus();
                });
              }),

          SizedBox(height: 16.h),

          _buildTermsSection(
              title: 'Agricultural Labor Safety',
              description:
                  'Safety protocols, emergency procedures, and labor law compliance.',
              icon: Icons.health_and_safety_outlined,
              isAccepted: _acceptedLabor,
              onChanged: (value) {
                setState(() {
                  _acceptedLabor = value;
                  _updateAcceptanceStatus();
                });
              }),

          SizedBox(height: 24.h),

          // Important notice
          Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  border: Border.all(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(77))),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Important Notice',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary)),
                      SizedBox(height: 4.h),
                      Text(
                          'By accepting these terms, you acknowledge that you understand your rights and responsibilities as a user of FarmConnect. All agricultural work must comply with local labor laws and safety regulations.',
                          style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.4)),
                    ])),
              ])),

          SizedBox(height: 24.h),

          // Contact information
          Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).dividerColor)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Need Help?',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface)),
                    SizedBox(height: 8.h),
                    Text(
                        'If you have questions about our terms or need assistance, contact our support team at support@farmconnect.com or call 1-800-FARM-HELP.',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(179),
                            height: 1.4)),
                  ])),
        ]));
  }

  Widget _buildTermsSection({
    required String title,
    required String description,
    required IconData icon,
    required bool isAccepted,
    required Function(bool) onChanged,
  }) {
    return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
                color: isAccepted
                    ? Theme.of(context).colorScheme.primary.withAlpha(77)
                    : Theme.of(context).dividerColor)),
        child: Column(children: [
          Row(children: [
            Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(26),
                    shape: BoxShape.circle),
                child: Icon(icon,
                    color: Theme.of(context).colorScheme.primary, size: 20.sp)),
            SizedBox(width: 12.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 4.h),
                  Text(description,
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(179),
                          height: 1.3)),
                ])),
          ]),
          SizedBox(height: 12.h),
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      _showTermsDialog(context, title, description);
                    },
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8.h)),
                    child: Text('Read Full Terms',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp, fontWeight: FontWeight.w500)))),
            SizedBox(width: 12.w),
            Checkbox(
                value: isAccepted,
                onChanged: (value) => onChanged(value ?? false)),
            Text('I Accept',
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface)),
          ]),
        ]));
  }

  void _showTermsDialog(
      BuildContext context, String title, String description) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(title,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                content: SingleChildScrollView(
                    child: Text(
                        'This is a placeholder for the full terms and conditions. In a real application, this would contain the complete legal text for $title.\n\n$description\n\nPlease ensure you read and understand all terms before accepting.',
                        style:
                            GoogleFonts.inter(fontSize: 14.sp, height: 1.5))),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w500))),
                ]));
  }

  void _updateAcceptanceStatus() {
    final allAccepted = _acceptedTerms && _acceptedPrivacy && _acceptedLabor;
    widget.onAccepted(allAccepted);
  }
}
