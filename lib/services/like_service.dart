import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

Future<void> queryLike({
  required String likerId,
  required String likedId,
}) async {
  try {
    // Check if the liked user has already liked the current user
    final response = await client
        .from('user_interactions')
        .select()
        .eq('viewer_id', likedId)
        .eq('viewed_user_id', likerId)
        .eq('interaction_type', 'liked')
        .maybeSingle();

    if (response == null) {
      print("No mutual like found. Just recording like...");
      await likeService(likerId: likerId, likedId: likedId);
      return;
    } else {
      print("Mutual like found — creating match");

      // Insert match
      await client.from("Matches").upsert({
        'user_1': likerId,
        'user_2': likedId,
      });

      // Log the new like interaction
      await client.from('user_interactions').insert({
        'viewer_id': likerId,
        'viewed_user_id': likedId,
        'interaction_type': 'liked',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return;
    }
  } catch (e) {
    print('❌ queryLike failed: $e');
    throw Exception('query failed');
  }
}

Future <void> dislikeService({
  required String userA, 
  required String userB,
}) async {
  try {
    await client.from('user_interactions').insert({
      'viewer_id': userA,
      'viewed_user_id': userB,
      'interaction_type': 'disliked',
      'timestamp': DateTime.now().toIso8601String(),
    });

  } catch(e) {
    print("Failed to dislike");
    rethrow;
  }
  }

Future<void> likeService({
  required String likerId,
  required String likedId,
}) async {
  try {
    print("Recording like interaction...");

    await client.from('user_interactions').insert({
      'viewer_id': likerId,
      'viewed_user_id': likedId,
      'interaction_type': 'liked',
      'timestamp': DateTime.now().toIso8601String(),
    });

    print("✅ Like interaction recorded");
  } catch (e) {
    print('❌ Failed to insert like interaction: $e');
    rethrow;
  }
}
