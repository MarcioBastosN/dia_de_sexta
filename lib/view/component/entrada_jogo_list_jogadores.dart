import 'package:dia_de_sexta/controller/controller_entrada_jogo.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/view/component/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../src/util/routes.dart';
import '../../model/jogo.dart';

class EntradaListajogadores extends StatefulWidget {
  const EntradaListajogadores({super.key});

  @override
  State<EntradaListajogadores> createState() => _EntradaListajogadoresState();
}

class _EntradaListajogadoresState extends State<EntradaListajogadores> {
  final _pontos = TextEditingController();
  ControllerEntradaJogo controllerJogo = ControllerEntradaJogo();

  _iniciaJogo() {
    if (controllerJogo.idTime_1.value != 0 &&
        controllerJogo.idTime_2.value != 0 &&
        _pontos.text.isNotEmpty) {
      Provider.of<Jogo>(context, listen: false).criarjgo(
        Jogo(
          equipe_1: controllerJogo.idTime_1.value,
          equipe_2: controllerJogo.idTime_2.value,
          pontosFimJogo: int.parse(_pontos.text.toString()),
        ),
      );
      Get.offNamed(AppRoutes.placar);
    } else {
      // _alertdialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Grupo>(context).carregaListaDropdownTimes(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GetX<ControllerEntradaJogo>(
            init: controllerJogo,
            builder: (_) {
              return DropdownButtonFormField(
                isExpanded: true,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                dropdownColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: "Time",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                items: Provider.of<Grupo>(context, listen: false)
                    .listaGruposDisponiveis
                    .where((e) => e.value != controllerJogo.idTime_2.value)
                    .toList(),
                onChanged: (value) =>
                    {controllerJogo.updateTime_1(newValue: value!)},
              );
            },
          ),
        ),

        GetX<ControllerEntradaJogo>(
          init: controllerJogo,
          builder: (_) {
            return DropdownButtonFormField(
              isExpanded: true,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              dropdownColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                isDense: true,
                labelText: "Time",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              items: Provider.of<Grupo>(context, listen: false)
                  .listaGruposDisponiveis
                  .where((e) => e.value != controllerJogo.idTime_1.value)
                  .toList(),
              onChanged: (value) =>
                  {controllerJogo.updateTime_2(newValue: value!)},
            );
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
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(8),
              ),
              onPressed: () => _iniciaJogo(),
              child: const Text('Iniciar'),
            ),
          ),
        ),
      ],
    );
  }
}
