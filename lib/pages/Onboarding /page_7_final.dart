import 'dart:io';
import 'package:flutter/material.dart';
import 'package:careerbrew/models/onboarding_data.dart';
import 'package:careerbrew/supabase/submit_to_supabase.dart';

class Page7Final extends StatelessWidget {

  final OnboardingData data;

  const Page7Final({super.key, required this.data});
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text("Welcome to our Network", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      )
    );
  }
}