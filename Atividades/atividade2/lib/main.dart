import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/tema_bloc.dart';
import 'blocs/tema_event.dart';
import 'blocs/tema_state.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (BuildContext context, state){
          return MaterialApp(
            title: 'atividade 2',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: state.color,
            ),
            home: const MyHomePage(title: 'pagina inicial'),
          );
        }
      ),
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, state){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: const Text("TRABALHO 2"),
            //backgroundColor: cor,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //se retornar true chama "imagemIara()", ao contrário chama "imagemIsabella()"
              state.photo ? imagemIara() : imagemIsabella(),
              //primeiro botão
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    context.read<ThemeBloc>().add(ThemeLightEvent());
                  });
                },
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  onPrimary: const Color.fromARGB(255, 2, 170, 170)
                ),
                child: const Text("Foto Iara")
              ),
              //segundo botão
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    context.read<ThemeBloc>().add(ThemeDarkEvent());
                  });
                },
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  onPrimary: const Color.fromARGB(255, 72, 0, 187)
                ),
                child: const Text("Foto Isabella")
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (state.photo == true) {
                  context.read<ThemeBloc>().add(ThemeDarkEvent());
                }
                else{
                  context.read<ThemeBloc>().add(ThemeLightEvent());
                }
              });
            },
            child: const Icon(Icons.account_circle, color: Colors.black,),
      ),
        );
      }
    );
  }
}

Widget imagemIara() {
  return Container(
    height: 320,
    width: 320,
    padding: const EdgeInsets.all(3.3),
    color: const Color.fromARGB(255, 0, 255, 255),
    child: Image.network('https://i.ibb.co/gS4dgjs/iara.jpg'),
  );
}
Widget imagemIsabella() {
  return Container(
    height: 320,
    width: 320,
    padding: const EdgeInsets.all(3.3),
    color: const Color.fromARGB(255, 72, 0, 187),
    child: Image.network('https://i.ibb.co/JQyPQ1s/isabella.jpg'),
  );
}