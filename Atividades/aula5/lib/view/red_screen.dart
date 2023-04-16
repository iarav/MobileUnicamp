import 'package:aula5/bloc/red_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blue_bloc.dart';

class RedScreen extends StatelessWidget {
  const RedScreen({super.key});
  /* BLOC usa stateless widget */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<RedBloc, RedState>(
          builder: (BuildContext context, RedState estado){
            int red = estado.amount;
            return Container(
              height: 300,
              color: Color.fromRGBO(red, 0, 0, 1),
            );
          }
        ),
        BlocBuilder<BlueBloc, BlueState>(
          builder: (BuildContext context, BlueState estado){
            int blue = estado.amount;
            return Container(
              height: 300,
              color: Color.fromRGBO(0, 0, blue, 1),
            );
          }
        ),
        Builder(
          builder: (BuildContext context){
            RedState redState = context.watch<RedBloc>().state;
            BlueState blueState = context.watch<BlueBloc>().state;
            return Container(
              height: 300,
              color: Color.fromRGBO(redState.amount, 0, blueState.amount, 1),
            );
          }
        )
      ],
    );
  }
}