import 'package:flutter/material.dart';
import 'package:careerbrew/models/onboarding_data.dart'; // Adjust path if needed

class Page3RoleSkills extends StatefulWidget {
  final VoidCallback onNext;
  final OnboardingData data;

  const Page3RoleSkills({
    super.key,
    required this.onNext,
    required this.data,
  });

  @override
  State<Page3RoleSkills> createState() => _Page3RoleSkillsState();
}

class _Page3RoleSkillsState extends State<Page3RoleSkills> {
  final List<String> lookingForOptions = [
    "Designer",
    "Engineer",
    "Biz Dev",
    "Marketing",
    "Product"
  ];

  final List<String> bringOptions = [
    "Technical skills",
    "Capital",
    "Idea",
    "Team",
    "Vision"
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selections from data in case user goes back
    selectedLookingFor = {...widget.data.lookingFor};
    selectedBring = {...widget.data.skills};
  }

  Set<String> selectedLookingFor = {};
  Set<String> selectedBring = {};

  void _handleNext() {
    widget.data.lookingFor = selectedLookingFor.toList();
    widget.data.skills = selectedBring.toList();
    widget.onNext();
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
              "Who are you looking for?",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: lookingForOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedLookingFor.contains(option),
                  onSelected: (selected) {
                    setState(() {
                      selected
                          ? selectedLookingFor.add(option)
                          : selectedLookingFor.remove(option);
                    });
                  },
                  selectedColor: const Color(0xFF62D8CF),
                  backgroundColor: const Color(0xFFEAEAEA),
                  labelStyle: const TextStyle(color: Colors.black),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            const Text(
              "What do you bring?",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: bringOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedBring.contains(option),
                  onSelected: (selected) {
                    setState(() {
                      selected
                          ? selectedBring.add(option)
                          : selectedBring.remove(option);
                    });
                  },
                  selectedColor: const Color(0xFF62D8CF),
                  backgroundColor: const Color(0xFFEAEAEA),
                  labelStyle: const TextStyle(color: Colors.black),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleNext,
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
}
