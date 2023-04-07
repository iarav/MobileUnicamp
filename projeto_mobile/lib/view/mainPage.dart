// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;
  
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: const Color.fromARGB(255, 1, 29, 62),
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
        body: TabBarView(
          children: [
          Container(
            color: Color.fromARGB(255, 91, 108, 153),
          ),
          Container(
            color: Color.fromARGB(255, 131, 216, 4),
          ),
          Container(
            color: Color.fromARGB(255, 216, 15, 4),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text('Fazer Reserva'),
          backgroundColor: const Color.fromARGB(255, 4, 64, 216),
      ), 
    ),
    );
  }
}