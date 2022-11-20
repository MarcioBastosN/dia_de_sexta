import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:flutter/material.dart';

class ListaJogadores extends StatefulWidget {
  const ListaJogadores({super.key});

  @override
  State<ListaJogadores> createState() => _ListaJogadoresState();
}

class _ListaJogadoresState extends State<ListaJogadores> {
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
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.cyan,
        body: Text("data"),
      ),
      onWillPop: showExitPopup,
    );
  }
}
