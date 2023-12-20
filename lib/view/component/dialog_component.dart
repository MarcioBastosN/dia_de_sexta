import 'package:flutter/material.dart';

class DialogComponent extends StatefulWidget {
  final String titulo;
  final String mensagem;
  final List<Widget>? listaCompomentes;

  const DialogComponent({
    super.key,
    required this.titulo,
    this.mensagem = '',
    this.listaCompomentes,
  });

  @override
  State<DialogComponent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DialogComponent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        widget.titulo,
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
      content: widget.mensagem.isNotEmpty
          ? Text(
              widget.mensagem,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            )
          : null,
      actions: widget.listaCompomentes,
    );
  }
}
