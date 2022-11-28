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
            ),
            children: [
              TextSpan(text: "Dia de ", style: TextStyle(color: Colors.blue)),
              TextSpan(
                text: 'Sexta',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 20),
            children: [
              TextSpan(text: "Seu placar do vôlei"),
            ],
          ),
        ),
      ],
    );
  }
}
