import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/home.dart';
import 'package:dia_de_sexta/view/view_jogadores.dart';
import 'package:dia_de_sexta/view/view_lista_placar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, int? indiceTela});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // defini o limite de jogadores no grupo
    Provider.of<Definicoes>(context, listen: false).loadDate().whenComplete(() {
      if (Provider.of<Definicoes>(context, listen: false).listaDef.isEmpty) {
        Provider.of<Definicoes>(context, listen: false)
            .adicionarDefinicao(Definicoes(numeroJogadores: 4));
      }
    });
    // inicializa os providers
    Provider.of<Grupo>(context, listen: false).loadDate();

    // verifica se possui times -se não houver cria.
    Provider.of<Time>(context, listen: false).loadDate().whenComplete(() {
      if (Provider.of<Time>(context, listen: false).listaTimes.isEmpty) {
        Provider.of<Time>(context, listen: false).adicionarTime(Time(
            nome: "Time 01",
            qtdParticipantes: Provider.of<Definicoes>(context, listen: false)
                .retornaLimiteJogadores()));
        Provider.of<Time>(context, listen: false).adicionarTime(Time(
            nome: "Time 02",
            qtdParticipantes: Provider.of<Definicoes>(context, listen: false)
                .retornaLimiteJogadores()));
      }
    });
  }

  final pageController = PageController();
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).copyWith().backgroundColor,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Home(),
          ListaPlacar(),
          ListaJogadores(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentindex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            // pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        currentIndex: currentindex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Historico",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: "Times",
          ),
        ],
      ),
    );
  }
}
