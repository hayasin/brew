import 'package:flutter/material.dart';
import 'package:careerbrew/models/onboarding_data.dart'; // Adjust path if needed

class Page2AboutYou extends StatelessWidget {
  final VoidCallback onNext;
  final OnboardingData data;

  const Page2AboutYou({
    super.key,
    required this.onNext,
    required this.data,
  });

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
              "Tell us about you",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// Tagline input
            _inputField(
              label: "Tagline (e.g. Ex Meta SWE, UIUC grad)",
              onChanged: (value) => data.tagline = value,
            ),
            const SizedBox(height: 16),

            /// Bio input
            _inputField(
              label: "Bio",
              hintText: "Your background, what you're building, what you're looking for...",
              maxLines: 5,
              onChanged: (value) => data.bio = value,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF62D8CF),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Next"),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required Function(String) onChanged,
    String? hintText,
    int maxLines = 1,
  }) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45),
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
