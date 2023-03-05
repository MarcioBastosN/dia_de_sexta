import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditaParticipante extends StatelessWidget {
  const EditaParticipante({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Numero de Participantes por grupo: ${Provider.of<Definicoes>(context).retornaLimiteJogadoresParaUmGrupo().toString()}",
                  maxLines: 2,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  onPressed: () =>
                      Provider.of<Definicoes>(context, listen: false)
                          .trocaNumeroParticipantes(context),
                  child: const Text(
                    "Alterar numero de participantes ",
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
