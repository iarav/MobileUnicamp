import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TEXTO PRINCIPAL'),
        const Text('texto extra'),
        const Icon(Icons.access_alarm),
        Column(
          children: [
            Expanded(child: Container(
              color: Colors.amber,
              child: const Text("Última coluna"),
            ))
          ]
        )
      ], 
    
    // return const Center(
    //   child: SizedBox(
    //     width: 150,
    //     height: 50,
    //     child: FittedBox(child: Text("Iara e Isa")),
    //   ),


      //COM EXPAND (Ocupa a tela toda)
      // child: SizedBox.expand(
      //   child: FittedBox(child: Text("Iara e Isa")),
      // ),
    );
  }
}