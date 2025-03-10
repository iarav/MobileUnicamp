// ignore: file_names
import 'package:flutter/material.dart';

import '../../model/routes.dart';
import '../../model/save_path.dart';
import 'admBloquearData.dart';
import 'admCalendario.dart';
import 'admVerReserva.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdmMainPage extends StatefulWidget {
  const AdmMainPage({super.key, required this.title});

  final String title;

  @override
  State<AdmMainPage> createState() => _AdmMainPageState();
}

class _AdmMainPageState extends State<AdmMainPage> {
  final Box _textformValues = Hive.box("textform_values");
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
                fontFamily: 'bright', color: Color(0xFF05173D), fontSize: 24),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Column(
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
                      Routes.home, //define your route name
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
          ],
          backgroundColor: Theme.of(context).primaryColor,
          bottom: const TabBar(tabs: [
            Tab(
              child: Text(
                "Ver Reservas",
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Bloquear Data",
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Calendário",
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            AdmVerReserva(),
            AdmBloquearData(),
            AdmCalendario(),
          ],
        ),
      ),
    );
  }
}
