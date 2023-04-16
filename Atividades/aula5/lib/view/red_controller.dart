import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blue_bloc.dart';
import '../bloc/red_bloc.dart';

class RedController extends StatelessWidget {
  const RedController({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: (){
                RedBloc redBloc = BlocProvider.of<RedBloc>(context);
                redBloc.add(SemRed());
              }, 
              child: const Text("SEM")
            ),
            ElevatedButton(
              onPressed: (){
                RedBloc redBloc = BlocProvider.of<RedBloc>(context);
                redBloc.add(PoucoRed());
              }, 
              child: const Text("POUCO")
            ),
            ElevatedButton(
              onPressed: (){
                RedBloc redBloc = BlocProvider.of<RedBloc>(context);
                redBloc.add(NormalRed());
              }, 
              child: const Text("NORMAL")
            ),
            ElevatedButton(
              onPressed: (){
                RedBloc redBloc = BlocProvider.of<RedBloc>(context);
                redBloc.add(MuitoRed());
              }, 
              child: const Text("MUITO")
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: (){
                BlueBloc redBloc = BlocProvider.of<BlueBloc>(context);
                redBloc.add(SemBlue());
              }, 
              child: const Text("SEM azul")
            ),
            ElevatedButton(
              onPressed: (){
                BlueBloc redBloc = BlocProvider.of<BlueBloc>(context);
                redBloc.add(PoucoBlue());
              }, 
              child: const Text("POUCO azul")
            ),
            ElevatedButton(
              onPressed: (){
                BlueBloc redBloc = BlocProvider.of<BlueBloc>(context);
                redBloc.add(NormalBlue());
              }, 
              child: const Text("NORMAL azul")
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: (){
                BlueBloc redBloc = BlocProvider.of<BlueBloc>(context);
                redBloc.add(MuitoBlue());
              }, 
              child: const Text("MUITO azul")
            ),
          ],
        ),
      ],
    );
  }
}