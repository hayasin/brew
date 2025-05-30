import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import 'package:careerbrew/models/onboarding_data.dart';
import 'package:careerbrew/pages/HomePage.dart'; // adjust if needed

Future<void> submitToSupabase(OnboardingData data, BuildContext context) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User not authenticated.")),
    );
    return;
  }

  // Step 1: Upload profile images to Supabase Storage
  List<String> uploadedUrls = [];

  for (int i = 0; i < data.profileImages.length; i++) {
    File image = data.profileImages[i];
    final ext = p.extension(image.path);
    final fileName = const Uuid().v4() + ext;
    final storagePath = "users/${user.id}/$fileName";

    try {
      await supabase.storage
          .from('profilepics') // your storage bucket name
          .upload(storagePath, image);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e")),
      );
      return;
    }

    final publicUrl = supabase.storage
        .from('profilepics')
        .getPublicUrl(storagePath);
    uploadedUrls.add(publicUrl);
  }

  // Step 2: Create user data map
  final userData = data.toMap(user.id, uploadedUrls);

  // Step 3: Upsert to Supabase table
  try {
    await supabase.from('UserData').upsert(userData);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Upload failed: $e")),
    );
    return;
  }

  // Step 4: Navigate to HomePage
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const MyHomePage()),
  );
}
