// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../model/routes.dart';
import '../../model/save_path.dart';
import 'minhasReservas.dart';
import 'opcoesReserva.dart';
import 'sobreAChurrascaria.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Box _textformValues = Hive.box("textform_values");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Color(0xFF05173D),
                    ),
                    onPressed: () async {
                      SavePath.changePath(Routes.home);
                      _textformValues.put('loggedUserId', null);
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(
                        context,
                        Routes.home,
                      );
                    },
                  ),
                  // const Text(
                  //   "Sair",
                  //   style: TextStyle(
                  //       fontFamily: 'bright', color: Color(0xFF05173D)),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      color: Color(0xFF05173D),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.editarPerfil, //define your route name
                      );
                    },
                  ),
                  // const Text(
                  //   "Editar perfil",
                  //   style: TextStyle(
                  //       fontFamily: 'bright', color: Color(0xFF05173D)),
                  // ),
                ],
              ),
            ),
          ], //action
          title: Text(
            widget.title,
            style: const TextStyle(
                fontFamily: 'bright', color: Color(0xFF05173D), fontSize: 24),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: const TabBar(tabs: [
            Tab(
              child: Text(
                "Opções de \nReserva",
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Ver Reservas",
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Sobre a \nChurrascaria",
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
        body: const TabBarView(
          children: [
            OpcoesDeReserva(),
            MinhasReservas(),
            SobreAChurrascaria(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routes.fazerReserva, //define your route name
            );
          },
          label: const Text(
            "Fazer Reserva",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Color.fromARGB(255, 24, 24, 24),
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF05173D),
        ),
      ),
    );
  }
}
