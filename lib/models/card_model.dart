class CardModel {
  final String id;
  final String firstName;
  final String lastName;
  late final String? tagline;
  final String? location;
  final String? mainPicUrl;
  final String? bio; // ✅ Add this line
  final List<String> skills;
  final List<String> traits;
  final List<String> lookingFor;

  CardModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.tagline,
    this.location,
    this.mainPicUrl,
    this.bio, // ✅ Add this line too
    required this.skills,
    required this.traits,
    required this.lookingFor,
  });

  factory CardModel.fromMap(Map<String, dynamic> data) {
    return CardModel(
      id: data['user_id'] as String,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      tagline: data['tagline'],
      location: data['location'],
      mainPicUrl: data['main_pic_url'],
      bio: data['bio'], // ✅ And this line
      skills: List<String>.from(data['skills'] ?? []),
      traits: List<String>.from(data['traits'] ?? []),
      lookingFor: List<String>.from(data['looking_for'] ?? []),
    );
  }

  Map<String, dynamic> toMap({bool includeNulls = false}) {
    final map = {
      'user_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'tagline': tagline,
      'location': location,
      'main_pic_url': mainPicUrl,
      'bio': bio,
      'skills': skills,
      'traits': traits,
      'looking_for': lookingFor,
    };

    // Remove nulls if desired
    if (!includeNulls) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }

  CardModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? tagline,
    String? location,
    String? mainPicUrl,
    String? bio,
    List<String>? skills,
    List<String>? traits,
    List<String>? lookingFor,
  }) {
    return CardModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      tagline: tagline ?? this.tagline,
      location: location ?? this.location,
      mainPicUrl: mainPicUrl ?? this.mainPicUrl,
      bio: bio ?? this.bio,
      skills: skills ?? List.from(this.skills),
      traits: traits ?? List.from(this.traits),
      lookingFor: lookingFor ?? List.from(this.lookingFor),
    );
  }
}
