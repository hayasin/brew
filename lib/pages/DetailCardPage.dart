import 'package:flutter/material.dart';
import 'package:careerbrew/models/card_model.dart';

class DetailCardPage extends StatelessWidget {
  final CardModel user;

  const DetailCardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "📝 About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "This is a placeholder for the detailed profile view. Here you'll see user's full info, more pics, and a connect button.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
