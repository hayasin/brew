import 'package:careerbrew/pages/MainPages/MatchesPage.dart';
import 'package:careerbrew/util/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:careerbrew/models/card_model.dart';
import 'package:careerbrew/util/CardView.dart';
import 'package:careerbrew/services/card_database.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:careerbrew/pages/MainPages/ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CardDatabase _db = CardDatabase();

  List<CardModel> _cards = [];
  bool _isLoading = true;
  String? expandedCardId;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    try {
      final cards = await _db.getCards();
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching cards: $e");
      setState(() => _isLoading = false);
    }
  }

  void handleToggleDetail(String cardId, bool isExpanded) {
    setState(() {
      expandedCardId = isExpanded ? cardId : null;
    });
  }

  String current_user_id = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          color: Colors.grey,
          activeColor: Color(0xFF3B82F6),
          // tabBackgroundColor: Color(0xFF3F4F6),
          padding: EdgeInsets.all(16),
          gap: 8,
          onTabChange: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }

            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchesPage()),
              );
            }
          },
          tabs: [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.handshake_outlined, text: "Matches"),
            GButton(icon: Icons.person, text: "Profile"),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Stack(
            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_cards.isEmpty)
                const Center(child: Text("No cards found."))
              else
                ..._cards.map((user) {
                  final isTopCard = user == _cards.last;
                  final isBlocked =
                      expandedCardId != null && expandedCardId != user.id;

                  return CardView(
                    user: user,
                    isTopCard: isTopCard,
                    isBlocked: isBlocked,
                    currentUserId: current_user_id,
                    onToggleDetail:
                        (isExpanded) => handleToggleDetail(user.id, isExpanded),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
