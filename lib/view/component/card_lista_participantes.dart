import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';

class CardListaParticipantes extends StatefulWidget {
  final Jogo? jogo;

  const CardListaParticipantes({super.key, this.jogo});

  @override
  State<CardListaParticipantes> createState() => _CardListaParticipantesState();
}

class _CardListaParticipantesState extends State<CardListaParticipantes> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, int index) {
        return Text(widget.jogo!.equipe_1.toString());
      },
    );
  }
}
