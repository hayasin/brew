// services/card_database.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:careerbrew/models/card_model.dart';

class CardDatabase {
  final _client = Supabase.instance.client;

Future<List<CardModel>> getCards() async {
  final userId = _client.auth.currentUser?.id;
  if (userId == null) return [];

  // Step 1: Get all user IDs the current user has interacted with
  final interactionsRes = await _client
      .from('user_interactions')
      .select('viewed_user_id')
      .eq('viewer_id', userId);

  final interactedIds = (interactionsRes as List)
      .map((e) => e['viewed_user_id'] as String)
      .toList();

  print("✅ Already interacted user IDs: $interactedIds");

  // Step 2: Query UserData table for new cards
  var query = _client
      .from('UserData')
      .select()
      .eq('profile_complete', true)
      .neq('user_id', userId); // Exclude self

  if (interactedIds.isNotEmpty) {
    query = query.not('user_id', 'in', interactedIds);
  }

  final response = await query.order('created_at', ascending: false);
  final data = List<Map<String, dynamic>>.from(response);

  return data.map((map) => CardModel.fromMap(map)).toList();
}
Future<CardModel?> getCurrentUserCard() async {
  final userId = _client.auth.currentUser?.id;
  if (userId == null) return null;

  final Map<String, dynamic> data =
      await _client.from('UserData').select().eq('user_id', userId).single();

  return CardModel.fromMap(data);
}

}
