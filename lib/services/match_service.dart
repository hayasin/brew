import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:careerbrew/models/card_model.dart';

final client = Supabase.instance.client;

class MatchService {
  Future<List<CardModel>> getMatchesForUser(String userId) async {
    try {
      print("🔍 Fetching matches for user: $userId");

      final response = await client
          .from('Matches')
          .select()
          .or('user_1.eq.$userId,user_2.eq.$userId');

      print("📦 Raw Matches response: $response");

      final List<String> matchedUserIds = (response as List)
          .map((match) =>
              match['user_1'] == userId ? match['user_2'] : match['user_1'])
          .cast<String>()
          .toList();

      print("✅ Matched user IDs: $matchedUserIds");

      if (matchedUserIds.isEmpty) {
        print("⚠️ No matches found.");
        return [];
      }

      final userData = await client
          .from('UserData')
          .select()
          .inFilter('user_id', matchedUserIds);

      print("📦 User data for matches: $userData");

      return List<Map<String, dynamic>>.from(userData)
          .map((map) => CardModel.fromMap(map))
          .toList();
    } catch (e) {
      print("❌ Error fetching matches: $e");
      return [];
    }
  }
}
