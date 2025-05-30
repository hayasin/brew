import 'package:careerbrew/pages/HomePage.dart';
import 'package:careerbrew/pages/MainPages/MatchesPage.dart';
import 'package:careerbrew/services/card_database.dart';
import 'package:careerbrew/util/EditCard.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../util/app_colors.dart';
import '../../models/card_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _cardDb = CardDatabase();
  CardModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _cardDb.getCurrentUserCard();
    setState(() {
      _currentUser = user;
      _isLoading = false;
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
          activeColor: AppColors.primaryBlue,
          selectedIndex: 2,
          padding: const EdgeInsets.all(16),
          gap: 8,
          tabBackgroundColor: AppColors.neutralLight,
          onTabChange: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            }

            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchesPage()),
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _currentUser == null
              ? const Center(child: Text('User profile not found.'))
              : Column(
                children: [
                  Expanded(
                    child: EditCard(
                      user: _currentUser!,
                      currentUserId: _currentUser!.id,
                    ),
                  ),
                ],
              ),
    );
  }
}
