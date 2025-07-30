import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/personal_info_tab_widget.dart';
import './widgets/preferences_tab_widget.dart';
import './widgets/professional_tab_widget.dart';
import './widgets/security_tab_widget.dart';

class ProfileManagement extends StatefulWidget {
  const ProfileManagement({Key? key}) : super(key: key);

  @override
  State<ProfileManagement> createState() => _ProfileManagementState();
}

class _ProfileManagementState extends State<ProfileManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userRole = 'farmer'; // This would come from user authentication

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text('Profile Management',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600)),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Navigate to settings
                  }),
            ]),
        body: Column(children: [
          // Profile Header
          _buildProfileHeader(),

          // Tab Bar
          Container(
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.inter(
                      fontSize: 12.sp, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: GoogleFonts.inter(
                      fontSize: 12.sp, fontWeight: FontWeight.w400),
                  tabs: const [
                    Tab(text: 'Personal'),
                    Tab(text: 'Professional'),
                    Tab(text: 'Preferences'),
                    Tab(text: 'Security'),
                  ])),

          // Tab Content
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            PersonalInfoTabWidget(userRole: userRole),
            ProfessionalTabWidget(userRole: userRole),
            PreferencesTabWidget(),
            SecurityTabWidget(),
          ])),
        ]));
  }

  Widget _buildProfileHeader() {
    return Container(
        padding: EdgeInsets.all(16.sp),
        child: Row(children: [
          // Profile Image
          Stack(children: [
            CircleAvatar(
                radius: 40.sp,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 38.sp,
                    child: CustomImageWidget(imageUrl: '', fit: BoxFit.cover))),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    padding: EdgeInsets.all(4.sp),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.camera_alt, size: 16.sp))),
          ]),
          SizedBox(width: 16.sp),

          // User Info
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('John Doe',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4.sp),
                Text(
                    userRole == 'farmer' ? 'Farm Owner' : 'Agricultural Worker',
                    style: GoogleFonts.inter(
                        color: Colors.white.withAlpha(204),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 8.sp),
                Row(children: [
                  Icon(Icons.verified, color: Colors.green, size: 16.sp),
                  SizedBox(width: 4.sp),
                  Text('Verified Profile',
                      style: GoogleFonts.inter(
                          color: Colors.white.withAlpha(230),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400)),
                ]),
              ])),

          // Rating
          Column(children: [
            Icon(Icons.star, color: Colors.amber, size: 24.sp),
            Text('4.8',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600)),
          ]),
        ]));
  }
}
