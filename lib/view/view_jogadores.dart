import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'compoment/alert_exit.dart';

class ListaJogadores extends StatefulWidget {
  const ListaJogadores({super.key});

  @override
  State<ListaJogadores> createState() => _ListaJogadoresState();
}

class _ListaJogadoresState extends State<ListaJogadores> {
  final _nomeJogador = TextEditingController();
  final focusJogador = FocusNode();

  @override
  void dispose() {
    _nomeJogador.dispose();
    focusJogador.dispose();
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

// adicona jogador
    addJogadorLista(BuildContext context) {
      focusJogador.requestFocus();
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Registar jogador',
          listaCompomentes: [
            TextFormCompoment(
              controller: _nomeJogador,
              focus: focusJogador,
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
                        focusJogador.unfocus();
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

// update jogador
    updateJogadorLista(BuildContext context, Jogador jogador) {
      focusJogador.requestFocus();
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Atualizar jogador',
          listaCompomentes: [
            TextFormCompoment(
              controller: _nomeJogador,
              focus: focusJogador,
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
                        jogador.nome = player;
                        Provider.of<Jogador>(context, listen: false)
                            .editarJogador(jogador);
                        _nomeJogador.value = const TextEditingValue(text: "");
                        focusJogador.unfocus();
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
      onWillPop: () => AlertExit().showExitPopup(context),
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
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 5 / 3,
                  ),
                  itemCount: listaJogadores.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.red,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(listaJogadores[index].nome.toString()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    updateJogadorLista(
                                        context, listaJogadores[index]);
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(Icons.edit),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Jogador>(context, listen: false)
                                        .removeJogador(listaJogadores[index]);
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
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


/*
ListView.builder(
                  itemCount: listaJogadores.length,
                  itemBuilder: ((context, int index) {
                    return Align(
                      alignment: Alignment.center,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                listaJogadores[index].id.toString(),
                              ),
                              Text(
                                listaJogadores[index].nome.toString(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updateJogadorLista(
                                      context, listaJogadores[index]);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.edit),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<Jogador>(context, listen: false)
                                      .removeJogador(listaJogadores[index]);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
*/