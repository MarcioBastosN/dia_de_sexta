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
        context.watch<Grupo>().jogadoresTimes(widget.timeId, context);
    return ListView.builder(
      itemCount: jogadores.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  jogadores[index].nome!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  context
                      .read<Jogador>()
                      .liberaJogadorId(jogadores[index].id!, context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
