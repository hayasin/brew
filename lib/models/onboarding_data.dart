import 'dart:io';

class OnboardingData {
  String? firstName;
  String? lastName;
  String? location;
  String? tagline;
  String? bio;
  bool building = false;
  bool working = false;
  bool cash = false;
  List<String> lookingFor = [];
  List<String> skills = [];
  List<String> traits = [];
  List<File> profileImages = []; // ✅ Up to 6 image files

  Map<String, dynamic> toMap(String userId, List<String> uploadedImageUrls) {
    final map = {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'location': location,
      'tagline': tagline,
      'bio': bio,
      'looking_for': lookingFor,
      'skills': skills,
      'traits': traits,
      'profile_complete': true,
    };

    // ✅ Add image URLs
    if (uploadedImageUrls.isNotEmpty) {
      map['main_pic_url'] = uploadedImageUrls[0];
      for (int i = 1; i < uploadedImageUrls.length && i <= 5; i++) {
        map['pic_${i + 1}_url'] = uploadedImageUrls[i];
      }
    }

    return map;
  }
}
