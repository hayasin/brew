import 'package:careerbrew/pages/LoginPage.dart';
import 'package:careerbrew/pages/MainPages/ProfilePage.dart';
import 'package:careerbrew/pages/Onboarding%20/OnboardingPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:careerbrew/pages/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before async calls

  print("initializing supabase=");
  try {
    await Supabase.initialize(
      url: "https://lhxqidivscrglxpdbeyw.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoeHFpZGl2c2NyZ2x4cGRiZXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwODU1NjQsImV4cCI6MjA2MjY2MTU2NH0.v9j9X-ue_b6EqwxMln8bKXEJxSxMHjM1ud8c7de0E9o",
    );
    print("Supabase initialized successfully.");
  } catch (e) {
    print("Supabase initialization failed");
  }

  print("🚀 Launching app...");
  runApp(SafeArea(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Swiper Example',
      theme: ThemeData(
        textTheme: GoogleFonts.soraTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      home: LoginPage(),
    );
  }
}

