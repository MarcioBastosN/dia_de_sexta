import 'package:dia_de_sexta/controller/controller_home_screen.dart';
import 'package:dia_de_sexta/view/home.dart';
import 'package:dia_de_sexta/view/view_jogadores.dart';
import 'package:dia_de_sexta/view/view_lista_placar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ControllerHomeScreen homeController = ControllerHomeScreen();
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Home(),
          ListaPlacar(),
          ListaJogadores(),
        ],
      ),
      bottomNavigationBar: GetX<ControllerHomeScreen>(
        init: homeController,
        builder: (_) {
          return BottomNavigationBar(
            onTap: (index) {
              homeController.updateCurrentIndex(newindex: index);
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            selectedItemColor: Theme.of(context).colorScheme.onSecondary,
            currentIndex: homeController.currentindex.value,
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
          );
        },
      ),
    );
  }
}
