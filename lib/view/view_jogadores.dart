import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaJogadores extends StatefulWidget {
  const ListaJogadores({super.key});

  @override
  State<ListaJogadores> createState() => _ListaJogadoresState();
}

class _ListaJogadoresState extends State<ListaJogadores> {
  final _nomeJogador = TextEditingController();

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => DialogComponent(
            titulo: "Você deseja sair ?",
            listaCompomentes: [
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  Navigator.of(context).popAndPushNamed(AppRoutes.home),
                },
                child: const Text('Ir para o inicio'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sair'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _nomeJogador.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<Jogador>(context, listen: false).loadDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listaJogadores = Provider.of<Jogador>(context).listaJogadores;

    addJogadorLista(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Registar jogador',
          listaCompomentes: [
            TextFormCompoment(
              controller: _nomeJogador,
              label: "Nome",
              inputType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text("salvar"),
                    onPressed: () {
                      final player = _nomeJogador.text.toString().trim();
                      if (player.isNotEmpty) {
                        Provider.of<Jogador>(context, listen: false)
                            .adicionarJogador(Jogador(
                          nome: player,
                        ));
                        _nomeJogador.value = const TextEditingValue(text: "");
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: SafeArea(
          child: Provider.of<Jogador>(context, listen: false)
                      .tamanhoListaJogadores() ==
                  0
              ? Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Adicione Jogadores"),
                    CircularProgressIndicator(),
                  ],
                ))
              : ListView.builder(
                  itemCount: listaJogadores.length,
                  itemBuilder: ((context, int index) {
                    return Text(listaJogadores[index].nome.toString());
                  }),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addJogadorLista(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
