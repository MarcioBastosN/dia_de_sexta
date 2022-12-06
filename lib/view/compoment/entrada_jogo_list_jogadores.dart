import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  String? time_1;
  String? time_2;

  _iniciaJogo() {
    if (time_1!.isNotEmpty &&
        time_2!.isNotEmpty &&
        _pontos.text.toString().isNotEmpty) {
      Provider.of<Jogo>(context, listen: false).criarjgo(
        Jogo(
          equipe_1: time_1,
          equipe_2: time_2,
          fimJogo: int.parse(_pontos.text.toString()),
        ),
      );

      Navigator.of(context).popAndPushNamed(AppRoutes.placar);
    } else {
      // _alertdialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Time>(context, listen: false).loadDate();
    final jogadores = Provider.of<Time>(context).getNomeTimes();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // select list
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              disabledItemFn: (String s) => s.startsWith(time_2.toString()),
            ),
            items: jogadores,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                isDense: true,
                labelText: "Time 1",
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
            ),
            onChanged: (String? value) {
              setState(() {
                time_1 = value;
              });
            },
          ),
        ),
        DropdownSearch<String>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            disabledItemFn: (String s) => s.startsWith(time_1.toString()),
          ),
          items: jogadores,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Time 2",
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
          ),
          onChanged: (String? value) {
            setState(() {
              time_2 = value;
            });
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
              child: const Text(
                'Iniciar',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
