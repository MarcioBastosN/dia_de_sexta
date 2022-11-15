import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaScreen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Theme.of(context).backgroundColor,
                  elevation: 0,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Desenvolvimento"),
                      Text("Marcio Bastos"),
                    ],
                  ),
                )
              ],
            ),
            // menu
            Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: PopupMenuButton(
                  color: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: "Home",
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).popAndPushNamed(AppRoutes.home);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.home),
                            Text("Home"),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: "Lista",
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .popAndPushNamed(AppRoutes.lista);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.list),
                            Text("Historico"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
