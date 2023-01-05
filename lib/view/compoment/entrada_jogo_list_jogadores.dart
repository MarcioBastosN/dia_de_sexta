import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_routes/routes.dart';
import '../../model/jogo.dart';

class EntradaListajogadores extends StatefulWidget {
  const EntradaListajogadores({super.key});

  @override
  State<EntradaListajogadores> createState() => _EntradaListajogadoresState();
}

class _EntradaListajogadoresState extends State<EntradaListajogadores> {
  final _pontos = TextEditingController();
  int? idTime_1;
  int? idTime_2;

  _iniciaJogo() {
    if (idTime_1 != null && idTime_2 != null && _pontos.text.isNotEmpty) {
      Provider.of<Jogo>(context, listen: false).criarjgo(
        Jogo(
          equipe_1: idTime_1,
          equipe_2: idTime_2,
          pontosFimJogo: int.parse(_pontos.text.toString()),
        ),
      );

      Navigator.of(context).popAndPushNamed(AppRoutes.placar);
    } else {
      // _alertdialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Grupo>(context).carregaTimesDisponiveis(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              isDense: true,
              labelText: "Time",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.cyan,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              labelStyle: TextStyle(
                color: Colors.white60,
              ),
            ),
            items: Provider.of<Grupo>(context, listen: false)
                .listaGruposDisponiveis,
            onChanged: (value) => {
              setState(() {
                idTime_1 = value;
              }),
            },
          ),
        ),

        DropdownButtonFormField(
          decoration: const InputDecoration(
            isDense: true,
            labelText: "Time",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.cyan,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            labelStyle: TextStyle(
              color: Colors.white60,
            ),
          ),
          items:
              Provider.of<Grupo>(context, listen: false).listaGruposDisponiveis,
          onChanged: (value) => {
            setState(() {
              idTime_2 = value;
            }),
          },
        ),

        // text pontos jogo
        TextFormCompoment(
          label: "Quantos Pontos vai o Jogo?",
          maxLength: 2,
          controller: _pontos,
          inputType: TextInputType.phone,
        ),

        // button iniciar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => _iniciaJogo(),
              child: const Text('Iniciar'),
            ),
          ),
        ),
      ],
    );
  }
}
