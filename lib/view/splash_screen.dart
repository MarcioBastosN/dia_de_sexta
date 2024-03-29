import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dia_de_sexta/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Theme.of(context).colorScheme.primary,
      splashIconSize: 250,
      animationDuration: const Duration(milliseconds: 500),
      duration: 500,
      splash: Lottie.asset('asset/AnikiHamster.json'),
      nextScreen: const HomeScreen(),
      pageTransitionType: PageTransitionType.theme,
    );
  }
}
