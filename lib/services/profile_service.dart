import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  // Future<void> testTaglineUpdate() async {
  //   final response =
  //       await Supabase.instance.client
  //           .from('UserData')
  //           .update({'tagline': 'Updated via test'})
  //           .eq('user_id', 'e83f4302-a4aa-4c1e-8633-410c7d299325')
  //           .select();

    // print('Test update result: ${response}');
  // }

Future<void> updateUserField({
  required String userId,
  required String field,
  required dynamic value,
}) async {
  try {
    // print(field);
    // print("Value we're using");
    // print(value);
    final response = await Supabase.instance.client
        .from('UserData')
        .update({field: value})
        .eq('user_id', userId)
        .select();    
    print('✅ Updated $field: $response');
  } catch (e) {
    print('❌ Error updating $field: $e');
    throw Exception('Failed to update $field: $e');
  }
}  

Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _client
        .from('UserData')
        .update(data)
        .eq('user_id', userId);

    if (response.error != null) {
      print('❌ Error updating profile: ${response.error!.message}');
      throw Exception(response.error!.message);
    } else {
      print('✅ Profile updated');
    }
  }
}
