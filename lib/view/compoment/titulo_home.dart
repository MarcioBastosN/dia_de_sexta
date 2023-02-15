import 'package:flutter/material.dart';

class TituloHome extends StatelessWidget {
  const TituloHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            children: const [
              TextSpan(text: "Dia de Sexta"),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            children: const [
              TextSpan(text: "Seu placar do vôlei"),
            ],
          ),
        ),
      ],
    );
  }
}
