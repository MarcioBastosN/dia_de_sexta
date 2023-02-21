import 'package:flutter/material.dart';

import 'dialog_component.dart';

class AlertExit {
  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => DialogComponent(
            titulo: "Você deseja sair do Dia de sexta?",
            listaCompomentes: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
