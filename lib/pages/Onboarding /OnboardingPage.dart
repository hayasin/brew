import 'package:careerbrew/models/onboarding_data.dart';
import 'package:careerbrew/pages/Onboarding%20/page_2_about_you.dart';
import 'package:careerbrew/pages/Onboarding%20/page_3_roles_skills.dart';
// import 'package:careerbrew/pages/Onboarding%20/page_4_personality.dart';
// import 'package:careerbrew/pages/Onboarding%20/page_4_personality.dart';
import 'package:careerbrew/pages/Onboarding%20/page_5_photointro.dart';
import 'package:careerbrew/pages/Onboarding%20/page_6_photo_select.dart';
import 'package:careerbrew/pages/Onboarding%20/page_7_final.dart';
import 'package:careerbrew/pages/Onboarding%20/page_7_photo_review.dart';
import 'package:flutter/material.dart';
import 'page_1_basic_info.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  double _progressValue() {
    // 4 pages: 0.25, 0.5, 0.75, 1.0
    return (_currentPage + 1) / 5;
  }

  final onboardingData = OnboardingData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: Column(
        children: [
          Container(height: 50,),
          LinearProgressIndicator(
            value: _progressValue(),
            backgroundColor: const Color(0xFFEAEAEA),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF62D8CF)),
            minHeight: 4,
          ),

          /// 🔸 Onboarding pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                  Page1BasicInfo(onNext: _nextPage, data: onboardingData),
                  Page2AboutYou(onNext: _nextPage, data: onboardingData),
                  Page3RoleSkills(onNext: _nextPage, data: onboardingData),
                  // Page4Personality(onNext: _nextPage, data: onboardingData),
                  Page5PhotoIntro(onNext: _nextPage, data: onboardingData),
                  Page6PhotoSelect(onNext: _nextPage, data: onboardingData),
                  // Page7Final(data: onboardingData),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
