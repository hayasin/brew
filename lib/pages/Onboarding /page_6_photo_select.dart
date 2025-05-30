import 'dart:io';
import 'package:careerbrew/supabase/submit_to_supabase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:careerbrew/models/onboarding_data.dart';
import 'package:reorderables/reorderables.dart'; // Add this import

class Page6PhotoSelect extends StatefulWidget {
  final VoidCallback onNext;
  final OnboardingData data;

  const Page6PhotoSelect({super.key, required this.onNext, required this.data});

  @override
  State<Page6PhotoSelect> createState() => _Page6PhotoSelectState();
}

class _Page6PhotoSelectState extends State<Page6PhotoSelect> {
  final List<File> selectedImages = [];

  Future<void> _pickImage() async {
    if (selectedImages.length >= 6) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImages.add(File(picked.path));
      });
    }
  }

  void _continue() {
    widget.data.profileImages = selectedImages;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageWidgets = [
      for (int i = 0; i < selectedImages.length; i++)
        ClipRRect(
          key: ValueKey(selectedImages[i].path), // Key is important for reorderables
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            selectedImages[i],
            width: 150,
            height: 175,
            fit: BoxFit.cover,
          ),
        ),
    ];

    if (selectedImages.length < 6) {
      imageWidgets.add(
        GestureDetector(
          key: const ValueKey('add_photo'),
          onTap: _pickImage,
          child: Container(
            width: 150,
            height: 175,
            decoration: BoxDecoration(
              color: const Color(0xFFEAEAEA),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF62D8CF),
                  blurRadius: 20,
                  spreadRadius: 4,
                  offset: const Offset(0, 0),
                )
              ]
            ),
            child: const Icon(Icons.add_a_photo, color: Colors.black45),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Upload up to 6 photos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            SizedBox(
              height: 370,
              child: SingleChildScrollView(
                primary: false,
                child: ReorderableWrap(
                  spacing: 12,
                  runSpacing: 12,
                  needsLongPressDraggable: false, // Reorder by tap & drag
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < selectedImages.length && newIndex < selectedImages.length) {
                        final item = selectedImages.removeAt(oldIndex);
                        selectedImages.insert(newIndex, item);
                      }
                    });
                  },
                  children: imageWidgets,
                ),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                widget.data.profileImages.addAll(selectedImages);
                await submitToSupabase(widget.data, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF62D8CF),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Finish"),
            ),
          ],
        ),
      ),
    );
  }
}
