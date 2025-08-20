import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_registration/user_registration.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/farmer_dashboard/farmer_dashboard.dart';
import '../presentation/job_search_and_filtering/job_search_and_filtering.dart';
import '../presentation/worker_dashboard/worker_dashboard.dart';
import '../presentation/booking_management/booking_management.dart';
import '../presentation/payment_and_earnings/payment_and_earnings.dart';
import '../presentation/job_posting/job_posting.dart';
import '../presentation/in_app_messaging/in_app_messaging.dart';
import '../presentation/profile_management/profile_management.dart';
import '../presentation/smart_farm_tools/smart_farm_tools.dart';
import '../presentation/community_forum/community_forum.dart';
import '../presentation/equipment_rental/equipment_rental.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String userRegistration = '/user-registration';
  static const String loginScreen = '/login-screen';
  static const String farmerDashboard = '/farmer-dashboard';
  static const String jobSearchAndFiltering = '/job-search-and-filtering';
  static const String workerDashboard = '/worker-dashboard';
  static const String bookingManagement = '/booking-management';
  static const String paymentAndEarnings = '/payment-and-earnings';
  static const String jobPosting = '/job-posting';
  static const String inAppMessaging = '/in-app-messaging';
  static const String profileManagement = '/profile-management';
  static const String smartFarmTools = '/smart-farm-tools';
  static const String communityForum = '/community-forum';
  static const String equipmentRental = '/equipment-rental';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    userRegistration: (context) => const UserRegistration(),
    loginScreen: (context) => LoginScreen(),
    farmerDashboard: (context) => FarmerDashboard(),
    jobSearchAndFiltering: (context) => JobSearchAndFiltering(),
    workerDashboard: (context) => WorkerDashboard(),
    bookingManagement: (context) => BookingManagement(),
    paymentAndEarnings: (context) => PaymentAndEarnings(),
    jobPosting: (context) => const JobPosting(),
    inAppMessaging: (context) => const InAppMessaging(),
    profileManagement: (context) => const ProfileManagement(),
    smartFarmTools: (context) => const SmartFarmTools(),
    communityForum: (context) => const CommunityForum(),
    equipmentRental: (context) => const EquipmentRental(),
    // TODO: Add your other routes here
  };
}
