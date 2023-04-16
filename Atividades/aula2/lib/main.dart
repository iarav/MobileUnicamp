import 'package:atividade2/view/first_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AtividadeAula3',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Aula 3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
            Tab(
              text: "Alarme",
              icon: Icon(Icons.access_alarm)
              ),
            Tab(
              text: "Home",
              icon: Icon(Icons.home)
              ),
            Tab(
              text: "Jogar",
              icon: Icon(Icons.gamepad)
              ),
          ]),
        ),
        body: TabBarView(children: [
          const FirstScreen(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: const FittedBox(child: Text("Iara e Isa")),
            ),
          ),
          // Container(
          //   color: const Color.fromARGB(255, 202, 255, 182),
          // ),
          Container(
            color: const Color.fromARGB(255, 7, 205, 255),
          ),
        ],),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), 
      ),
    );
  }
}
