import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacarComponent extends StatefulWidget {
  final double tamanhoWidth;
  final double tamanhoHeight;
  final String titulo;
  final String placar;
  final void Function() adciona;
  final void Function() decrementa;

  const PlacarComponent({
    super.key,
    required this.tamanhoHeight,
    required this.tamanhoWidth,
    required this.titulo,
    required this.placar,
    required this.adciona,
    required this.decrementa,
  });

  @override
  State<PlacarComponent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PlacarComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.tamanhoWidth,
      height: widget.tamanhoHeight,
      color: Theme.of(context).copyWith().primaryColor,
      child: Column(
        children: [
          Text(
            widget.titulo,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            widget.placar,
            style: Theme.of(context).textTheme.headline1,
            // style: GoogleFonts.getFont('Play'),
            textScaleFactor: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: widget.adciona,
                child: const Icon(Icons.add),
              ),
              ElevatedButton(
                onPressed: widget.decrementa,
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
