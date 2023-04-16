import 'package:aula5/view/form_bloc.dart';
import 'package:aula5/view/red_controller.dart';
import 'package:aula5/view/red_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/blue_bloc.dart';
import 'bloc/checkbox_bloc.dart';
import 'bloc/red_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) {
              return RedBloc(RedState(amount: 0));
            },
          ),
          BlocProvider(
            create: (BuildContext context) {
              return BlueBloc(BlueState(amount: 0));
            },
          ),
          BlocProvider(
            create: (BuildContext context) {
              return CheckBoxBloc();
            },
          ),
        ], 
        child: IndexedStack(
          index: _currentScreen,
          children: const [
            RedController(),
            SingleChildScrollView(child: RedScreen()),
            FormBloc(),
          ],
        ),
      ), 
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_circle), 
            label: "Tela Azul",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded), 
            label: "Tela Vermelha"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done), 
            label: "Tela Amarela"
          ),
        ],
        currentIndex: _currentScreen,
        onTap: (int novoItem) {
          setState(() => _currentScreen = novoItem); 
        },
        fixedColor: const Color.fromARGB(255, 2, 0, 144),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Avisa ao flutter para renderizar a tela
          setState(() {
            _currentScreen = (++_currentScreen) % 3;
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
