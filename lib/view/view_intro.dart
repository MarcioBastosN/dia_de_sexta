import 'package:dia_de_sexta/src/util/routes.dart';
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
              imageUrl: 'asset/AnikiHamster.json',
              bgColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
            OnboardingPageModel(
              title: 'Crie times e adicione partipantes',
              description: 'Vai começar a disputa :)',
              imageUrl: 'asset/team_members.json',
              bgColor: Theme.of(context).colorScheme.tertiary,
              textColor: Theme.of(context).colorScheme.onTertiary,
            ),
            OnboardingPageModel(
              title: 'Chega de Grupinho!!!',
              description:
                  'Utilize a função sorteio, para deixar o jogo equilibrado.',
              imageUrl: 'asset/block.json',
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            OnboardingPageModel(
              title: 'Vamos Jogar',
              description: 'Após cada jogo você pode compartinhar sua partida.',
              imageUrl: 'asset/smash.json',
              bgColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ]),
    );
  }
}
