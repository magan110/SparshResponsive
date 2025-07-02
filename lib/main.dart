import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning2/screens/DsrVisitScreen.dart';
import 'package:learning2/screens/Home_screen.dart';
import 'package:learning2/screens/firebase_api.dart';
import 'package:learning2/screens/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:learning2/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create the notification provider
  final notificationProvider = NotificationProvider();

  // Initialize Firebase API with the notification provider
  await FirebaseApi().initNotification(notificationProvider);

  // Initialize background location service
  // final backgroundService = BackgroundLocationService();

  // Initialize the service but don't auto-start it
  // This ensures the user must manually start the service
  // await backgroundService.initializeService(autoStart: false);

  // Background service initialized but not started - user must start it manually

  runApp(
    ChangeNotifierProvider.value(
      value: notificationProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPARSH',
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}
