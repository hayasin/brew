import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:careerbrew/models/onboarding_data.dart';

class Page5PhotoIntro extends StatefulWidget {
  final VoidCallback onNext;
  final OnboardingData data;

  const Page5PhotoIntro({super.key, required this.onNext, required this.data});

  @override
  State<Page5PhotoIntro> createState() => _Page5PhotoIntroState();
}

class _Page5PhotoIntroState extends State<Page5PhotoIntro> {
  File? _mainPhoto;

  Future<void> _pickMainPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _mainPhoto = File(picked.path);
      });
    }
  }

  void _continue() {
    if (_mainPhoto != null) {
      widget.data.profileImages = [_mainPhoto!]; // main photo is first
      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a profile photo.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Start with your profile photo",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              "This photo will be your main image on the card.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _pickMainPhoto,
              child: _mainPhoto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(_mainPhoto!, height: 300, width: 350, fit: BoxFit.cover),
                    )
                  : Container(
                      height: 300,
                      width: 350,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF62D8CF),
                            blurRadius:20,
                            spreadRadius: 4,
                            offset: const Offset(0,0),
                          )

                        ],
                      ),
                      child: const Icon(Icons.person, size: 80, color: Colors.black26),
                    ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _continue,
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
