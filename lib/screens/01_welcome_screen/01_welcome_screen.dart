import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/welcome/welcome_bottom_section.dart';
import 'package:Wetieko/widgets/welcome/network_background.dart';
import 'package:Wetieko/screens/02_onboarding_screen/02_name_input_screen.dart'; // ✅ Name input screen import edildi

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNameInput() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NameInputScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,
      body: Stack(
        children: [
          const Positioned.fill(child: NetworkBackground()),
          Positioned(
            bottom: 100,
            left: 24,
            right: 24,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: WelcomeBottomSection(
                  onStartPressed: _navigateToNameInput, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
