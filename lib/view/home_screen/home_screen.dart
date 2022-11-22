import 'package:dia_de_sexta/view/home.dart';
import 'package:dia_de_sexta/view/view_jogadores.dart';
import 'package:dia_de_sexta/view/view_lista_placar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, int? indiceTela});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            pageController.jumpToPage(index);
          });
        },
        // showSelectedLabels: true,
        // showUnselectedLabels: false,
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
            icon: Icon(Icons.playlist_add_check_circle_outlined),
            label: "Jogadores",
          ),
        ],
      ),
    );
  }
}