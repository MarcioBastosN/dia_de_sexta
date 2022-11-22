import 'package:flutter/material.dart';

class CardListaPlacar extends StatefulWidget {
  final String indexCard;
  final String equipe1;
  final String equipe2;
  final String pontosEq1;
  final String pontosEq2;
  final String data;
  final String tempo;

  const CardListaPlacar({
    super.key,
    required this.indexCard,
    required this.equipe1,
    required this.equipe2,
    required this.pontosEq1,
    required this.pontosEq2,
    required this.data,
    required this.tempo,
  });

  @override
  State<CardListaPlacar> createState() => _CardListaPlacarState();
}

class _CardListaPlacarState extends State<CardListaPlacar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Card(
                  elevation: 2.0,
                  color: Theme.of(context).copyWith().backgroundColor,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [Text("Jogo\n ${widget.indexCard}")],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(widget.equipe1),
                              Text(widget.pontosEq1),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(widget.equipe2),
                              Text(widget.pontosEq2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Data: ${widget.data}"),
              Text("tempo: ${widget.tempo}"),
            ],
          )
        ],
      ),
    );
  }
}
