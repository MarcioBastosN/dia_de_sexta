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
              title: 'Smash, seu placar do volêi',
              description: 'Vai jogar!, salva o placar para postar depois.',
              imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
              bgColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
            OnboardingPageModel(
              title: 'Crie times e adicione partipantes',
              description: 'Vai começar a disputa :)',
              imageUrl:
                  'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
              bgColor: Theme.of(context).colorScheme.tertiary,
              textColor: Theme.of(context).colorScheme.onTertiary,
            ),
            OnboardingPageModel(
              title: 'Chega de Grupimho!!!',
              description:
                  'Utilize a função sorteio, para deixar o jogo mais divertido.',
              imageUrl: 'https://i.ibb.co/420D7VP/building.png',
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            OnboardingPageModel(
              title: 'Vamos Jogar',
              description: 'Após cada jogo você pode compartinhar sua partida.',
              imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
              bgColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ]),
    );
  }
}
