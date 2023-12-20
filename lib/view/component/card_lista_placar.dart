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
                  color: Theme.of(context).colorScheme.secondary,
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [Text("Jogo\n ${widget.indexCard}")],
                          ),
                          Column(
                            children: [
                              Text(widget.equipe1),
                              Text(widget.pontosEq1),
                            ],
                          ),
                          Column(
                            children: [
                              Text(widget.equipe2),
                              Text(widget.pontosEq2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          DefaultTextStyle(
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    Text(widget.data),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    Text(widget.tempo),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
