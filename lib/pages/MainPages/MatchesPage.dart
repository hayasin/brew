import 'package:careerbrew/pages/HomePage.dart';
import 'package:careerbrew/pages/MainPages/ProfilePage.dart';
import 'package:careerbrew/services/match_service.dart';
import 'package:careerbrew/models/card_model.dart';
import 'package:careerbrew/util/ProfileView.dart';
import 'package:careerbrew/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final MatchService _matchService = MatchService();
  List<CardModel> _matches = [];

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  void loadMatches() async {
    print("Loading matches");
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final matches = await _matchService.getMatchesForUser(userId);
    setState(() {
      _matches = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          color: Colors.grey,
          activeColor: const Color(0xFF3B82F6),
          selectedIndex: 1,
          padding: const EdgeInsets.all(16),
          gap: 8,
          onTabChange: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }

            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            }
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.handshake_outlined, text: "Matches"),
            GButton(icon: Icons.person, text: "Profile"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Matches Preview
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final user = _matches[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: Navigate to match detail or chat
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(user:user)));

                  },
                  child: Padding(
              
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              user.mainPicUrl ?? '',
                              width: 100,
                              height: 125,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.firstName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(color: AppColors.secondaryPurple, thickness: 2),
          ),

          // Placeholder for chat previews
          Container(
            color: Colors.black,
            height: 300,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
