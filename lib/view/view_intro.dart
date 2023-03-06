import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/onboarding_page_model.dart';
import 'package:flutter/material.dart';

import 'intro/onboarding_page_present.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
          onFinish: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
          },
          onSkip: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
          },
          pages: [
            OnboardingPageModel(
              title: 'Smash, seu app de volêi',
              description:
                  'Enjoy the best of the world in the palm of your hands.',
              imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            OnboardingPageModel(
              title: 'Connect with your friends.',
              description: 'Connect with your friends anytime anywhere.',
              imageUrl:
                  'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            OnboardingPageModel(
              title: 'Bookmark your favourites',
              description:
                  'Bookmark your favourite quotes to read at a leisure time.',
              imageUrl: 'https://i.ibb.co/420D7VP/building.png',
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            OnboardingPageModel(
              title: 'Follow creators',
              description:
                  'Follow your favourite creators to stay in the loop.',
              imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ]),
    );
  }
}
