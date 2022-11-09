import 'package:flutter/material.dart';

class DialogComponent extends StatefulWidget {
  final String titulo;
  final String mensagem;
  final List<Widget>? listaCompomentes;

  const DialogComponent({
    super.key,
    required this.titulo,
    required this.mensagem,
    this.listaCompomentes,
  });

  @override
  State<DialogComponent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DialogComponent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        widget.titulo,
        style: const TextStyle(color: Colors.white),
      ),
      content: Text(widget.mensagem),
      actions: widget.listaCompomentes,
    );
  }
}
