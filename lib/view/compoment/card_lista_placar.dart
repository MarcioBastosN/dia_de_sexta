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
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
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
                              SizedBox(
                                width: 120,
                                child: Text(
                                  widget.equipe1,
                                ),
                              ),
                              Text(widget.pontosEq1),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  widget.equipe2,
                                ),
                              ),
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
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                  ),
                  Text(widget.data),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                    // color: Colors.white,
                  ),
                  Text(widget.tempo),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
