import 'dart:io';
import 'package:flutter/material.dart';
import 'package:careerbrew/models/onboarding_data.dart';
import 'package:careerbrew/supabase/submit_to_supabase.dart';

class Page7PhotoReview extends StatelessWidget {
  final OnboardingData data;

  const Page7PhotoReview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
              "Review your photos",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  final File moved = data.profileImages.removeAt(oldIndex);
                  data.profileImages.insert(newIndex, moved);
                },
                children: [
                  for (int i = 0; i < data.profileImages.length; i++)
                    ListTile(
                      key: ValueKey(i),
                      leading: Image.file(data.profileImages[i], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text("Photo ${i + 1}"),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await submitToSupabase(data, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF62D8CF),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Finish"),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}