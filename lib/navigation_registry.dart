import 'package:flutter/material.dart';
// Import all your screens here
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/mail_screen.dart';
import 'dsr_entry_screen/dsr_entry.dart';
import 'screens/AccountsStatementPage.dart';
import 'screens/ActivitySummaryPage.dart';
import 'screens/EmployeeDashboardPage.dart';
import 'screens/GrcLeadEntryPage.dart';
import 'screens/PainterKycTrackingPage.dart';
import 'screens/RetailerRegistrationPage.dart';
import 'screens/SchemeDocumentPage.dart';
import 'screens/UniversalOutletRegistrationPage.dart';
import 'screens/token_scan.dart';
// import 'screens/live_location_screen.dart'; // Uncomment if available

class AppRoute {
  final String title;
  final String type;
  final Widget Function(BuildContext) builder;
  const AppRoute(this.title, this.type, this.builder);
}

final List<AppRoute> appRoutes = [
  AppRoute('Dashboard', 'Screen', (context) => DashboardScreen()),
  AppRoute('Profile', 'Screen', (context) => ProfilePage()),
  AppRoute('Mail', 'Screen', (context) => MailScreen()),
  AppRoute('DSR Entry', 'Screen', (context) => DsrEntry()),
  AppRoute('Accounts Statement', 'Report', (context) => AccountsStatementPage()),
  AppRoute('Activity Summary', 'Report', (context) => ActivitySummaryPage()),
  AppRoute('Employee Dashboard', 'Screen', (context) => EmployeeDashboardPage()),
  AppRoute('GRC Lead Entry', 'Screen', (context) => GrcLeadEntryPage()),
  AppRoute('Painter KYC Tracking', 'Screen', (context) => PainterKycTrackingPage()),
  AppRoute('Retailer Registration', 'Screen', (context) => RetailerRegistrationPage()),
  AppRoute('Scheme Document', 'Screen', (context) => SchemeDocumentPage()),
  AppRoute('Universal Outlet Registration', 'Screen', (context) => UniversalOutletRegistrationPage()),
  AppRoute('Token Scan', 'Screen', (context) => TokenScanPage()),
  // AppRoute('Live Location', 'Screen', (context) => LiveLocationScreen()), // Uncomment if available
  // Add more screens/reports here as needed
]; 