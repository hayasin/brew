import 'package:flutter/material.dart';
import 'package:careerbrew/util/app_colors.dart';
import 'package:careerbrew/models/card_model.dart';

class ProfileView extends StatelessWidget {
  final CardModel user;

  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width - 20;
    const cardHeight = 340.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child:Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20), 
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: Image.network(
                        user.mainPicUrl!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.2),
                        colorBlendMode: BlendMode.darken
                      )
                    )
                  ]
                )
              ) ,
              ),

              const SizedBox(height: 24,),
              Row(
                children: [
                  IntrinsicWidth(
                    child: Text(
                      "${user.firstName} ${user.lastName}",
                      style: const TextStyle(
                        color: AppColors.secondaryPurple, 
                        fontSize: 14
                      ),
                      
                    )
                  )
                ],
                ),

            
      
            const SizedBox(height: 24),
      
            // Bottom Sheet Style Content
          ],
        ),
      ),
    );
  }
}
