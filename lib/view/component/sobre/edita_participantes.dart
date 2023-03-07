import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditaParticipante extends StatelessWidget {
  const EditaParticipante({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Numero de Participantes por grupo: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () => Provider.of<Definicoes>(context, listen: false)
                .trocaNumeroParticipantes(context),
            child: Text(
              Provider.of<Definicoes>(context)
                  .retornaLimiteJogadoresParaUmGrupo()
                  .toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
