import 'package:aula4/view/page2.dart';
import 'package:flutter/material.dart';

import 'model/login_data.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginData _loginData = LoginData();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        body: TabBarView(
          children: [
          pagina1(),
          const Pagina2(),
          Container(
            color: const Color.fromARGB(255, 4, 64, 216),
          ),
        ],
      ),
      floatingActionButton: Row
      (
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          ),
          FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.save),
          ),
          FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              label: const Text('Fazer Reserva'),
              backgroundColor: const Color.fromARGB(255, 4, 64, 216),
          ) 
        ],
      ), 
    ),
    );
  }

  Widget pagina1(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          usernameField(),
          passwordField(),
          ElevatedButton(
            onPressed: (){
             if( _formKey.currentState!.validate()){
              _formKey.currentState!.save();
              _loginData.doSomething();
             }
            }, 
            child: const Text("Login")
          ),
        ],
      ),
    );
  }

  Widget usernameField(){
    return TextFormField(
      validator: (String? value){
        if(value!=null){
          if(value.isEmpty){
            return "Campo obrigatório.";
          }
        }else{
          return "Insira algum valor.";
        }
        return null;
      },
      onSaved: (String? value){
        //Se nulo vira ""
        _loginData.username = value ?? "";
      },
    );
  }

  Widget passwordField(){
    return TextFormField(
      obscureText: true,
      validator: (String? value){
        if(value!=null){
          if(value.isEmpty){
            return "Campo obrigatório.";
          }
          if(value.length<10){
            return "Minimo de 10 letras";
          }
        }
        return null;
      },
      onSaved: (String? value){
        //Se nulo vira ""
        _loginData.password = value ?? "";
      },
    );
  }
}


