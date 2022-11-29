import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridTimes extends StatelessWidget {
  const GridTimes({super.key});

  @override
  Widget build(BuildContext context) {
    final listaTimes = Provider.of<Time>(context).listaTimes;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 4 / 3.5,
      ),
      itemCount: listaTimes.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(index.toString()),
        );
      },
    );
  }
}
