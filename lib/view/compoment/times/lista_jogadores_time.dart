// import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListajogadoresTime extends StatefulWidget {
  const ListajogadoresTime({super.key, required this.timeId});

  final int timeId;

  @override
  State<ListajogadoresTime> createState() => _ListajogadoresTimeState();
}

class _ListajogadoresTimeState extends State<ListajogadoresTime> {
  @override
  Widget build(BuildContext context) {
    List<Jogador> jogadores =
        Provider.of<Grupo>(context).jogadoresTimes(widget.timeId, context);
    return ListView.builder(
      itemCount: jogadores.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            children: [
              Text(
                jogadores[index].nome!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  //remove do grupo e libera o jogador
                  Provider.of<Jogador>(context, listen: false)
                      .liberaJogadorId(jogadores[index].id!, context);
                },
                icon: const Icon(Icons.delete),
              )
            ],
          ),
        );
      },
    );
  }
}
