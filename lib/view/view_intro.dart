import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/src/util/routes.dart';
import 'package:dia_de_sexta/model/onboarding_page_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'intro/onboarding_page_present.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Definicoes>().loadDate().whenComplete(() {
      if (context.read<Definicoes>().listaDef.isEmpty) {
        context
            .read<Definicoes>()
            .adicionarDefinicao(Definicoes(numeroJogadores: 4));
      }
    });
    context.read<Grupo>().loadDate();
    // verifica se possui times -se não houver cria.
    context.read<Time>().loadDate().whenComplete(() {
      if (context.read<Time>().listaTimes.isEmpty) {
        context
            .read<Time>()
            .adicionarTime(Time(nome: "Time 01", qtdParticipantes: 0));
        context
            .read<Time>()
            .adicionarTime(Time(nome: "Time 02", qtdParticipantes: 0));
      }
    });

    return Scaffold(
      body: OnboardingPagePresenter(
          onFinish: () {
            Get.offAndToNamed(AppRoutes.splash);
          },
          onSkip: () {
            Get.offAndToNamed(AppRoutes.splash);
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
