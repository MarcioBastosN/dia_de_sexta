import 'package:dia_de_sexta/model/grupo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListajogadoresTime extends StatefulWidget {
  const ListajogadoresTime({super.key, required this.grupo});

  final Grupo grupo;

  @override
  State<ListajogadoresTime> createState() => _ListajogadoresTimeState();
}

class _ListajogadoresTimeState extends State<ListajogadoresTime> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Provider.of<Grupo>(context, listen: false)
          .qtdjogadoresTime(widget.grupo.id!),
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            children: [
              Text(widget.grupo.idJogador!),
              Text(
                widget.grupo.idJogador!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  //
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
