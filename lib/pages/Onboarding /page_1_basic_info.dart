import 'package:flutter/material.dart';
import 'package:careerbrew/models/onboarding_data.dart';

class Page1BasicInfo extends StatefulWidget {
  final VoidCallback onNext;
  final OnboardingData data;

  const Page1BasicInfo({
    super.key,
    required this.onNext,
    required this.data,
  });

  @override
  State<Page1BasicInfo> createState() => _Page1BasicInfoState();
}

class _Page1BasicInfoState extends State<Page1BasicInfo> {
  Set<String> selectedIntents = {};

  void _toggleIntent(String value) {
    setState(() {
      if (selectedIntents.contains(value)) {
        selectedIntents.remove(value);
      } else {
        selectedIntents.add(value);
      }

      widget.data.building = selectedIntents.contains("Build");
      widget.data.working = selectedIntents.contains("Work");
      widget.data.cash = selectedIntents.contains("Quick Cash");
    });
  }

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
              "Let's get started",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _inputField(
              label: "First Name",
              onChanged: (value) => widget.data.firstName = value,
            ),
            const SizedBox(height: 12),
            _inputField(
              label: "Last Name",
              onChanged: (value) => widget.data.lastName = value,
            ),
            const SizedBox(height: 12),
            _inputField(
              label: "Location (e.g. SF, NYC, Remote)",
              onChanged: (value) => widget.data.location = value,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _intentBox("Build", "🔧"),
                _intentBox("Work", "💼"),
                _intentBox("Quick Cash", "💸"),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.onNext,
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
  }) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
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

  Widget _intentBox(String label, String emoji) {
    final isSelected = selectedIntents.contains(label);
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleIntent(label),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF62D8CF) : const Color(0xFF1D1E2C),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            "$emoji $label",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
