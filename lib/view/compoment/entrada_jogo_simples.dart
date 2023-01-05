// import 'package:dia_de_sexta/app_routes/routes.dart';
// import 'package:dia_de_sexta/model/jogo.dart';
// import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'dialog_component.dart';

// class EntradaJogoSimples extends StatefulWidget {
//   const EntradaJogoSimples({super.key});

//   @override
//   State<EntradaJogoSimples> createState() => _EntradaJogoSimplesState();
// }

// class _EntradaJogoSimplesState extends State<EntradaJogoSimples> {
//   final _time1 = TextEditingController();
//   final _time2 = TextEditingController();
//   final _pontos = TextEditingController();
//   final _focusP1 = FocusNode();
//   final _focusP2 = FocusNode();
//   final _focusPontos = FocusNode();

//   @override
//   void dispose() {
//     super.dispose();
//     _time1.dispose();
//     _time2.dispose();
//     _pontos.dispose();
//     _focusPontos.dispose();
//     _focusP1.dispose();
//     _focusP2.dispose();
//   }

//   _iniciaJogo() {
//     final eq1 = _time1.text.toString().trim();
//     final eq2 = _time2.text.toString().trim();
//     if (eq1.isNotEmpty &&
//         eq2.isNotEmpty &&
//         _pontos.text.toString().isNotEmpty) {
//       Provider.of<Jogo>(context, listen: false).criarjgo(
//         Jogo(
//           equipe_1: eq1,
//           equipe_2: eq2,
//           fimJogo: int.parse(_pontos.text.toString()),
//         ),
//       );

//       Navigator.of(context).popAndPushNamed(AppRoutes.placar);
//     } else {
//       _alertdialog(context);
//     }
//   }

//   void _alertdialog(BuildContext context) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => DialogComponent(
//         titulo: "Ops!",
//         mensagem: const Text("Verifique os campos."),
//         listaCompomentes: [
//           ElevatedButton(
//             child: const Text("fechar"),
//             onPressed: () {
//               Navigator.of(context).pop();
//               setState(() {
//                 _focusP1.requestFocus();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextFormCompoment(
//           label: "Time 1",
//           controller: _time1,
//           inputType: TextInputType.text,
//           perfixIcon: Icons.people,
//           focus: _focusP1,
//           submit: () {
//             setState(() {
//               _focusP2.requestFocus();
//             });
//           },
//         ),
//         TextFormCompoment(
//           label: "Time 2",
//           controller: _time2,
//           inputType: TextInputType.text,
//           perfixIcon: Icons.people,
//           focus: _focusP2,
//           submit: () {
//             setState(() {
//               _focusPontos.requestFocus();
//             });
//           },
//         ),
//         TextFormCompoment(
//           label: "Quantos Pontos vai o Jogo?",
//           maxLength: 2,
//           controller: _pontos,
//           inputType: TextInputType.phone,
//           focus: _focusPontos,
//         ),

//         // button iniciar
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: SizedBox(
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () => _iniciaJogo(),
//               child: const Text(
//                 'Iniciar',
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
