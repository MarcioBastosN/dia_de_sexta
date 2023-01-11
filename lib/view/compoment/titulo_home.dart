import 'package:flutter/material.dart';

class TituloHome extends StatelessWidget {
  const TituloHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            children: [
              TextSpan(
                text: "Dia de ",
              ),
              TextSpan(
                text: 'Sexta',
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 20,
            ),
            children: [
              TextSpan(text: "Seu placar do vôlei"),
            ],
          ),
        ),
      ],
    );
  }
}
