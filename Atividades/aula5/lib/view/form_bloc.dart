import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/checkbox_bloc.dart';

class FormBloc extends StatelessWidget {
  const FormBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckBoxBloc, bool>(
      builder: (context, bool state) {
        return Checkbox(
          value: state, 
          onChanged: (bool? value){
            if(value!=null){
              BlocProvider.of<CheckBoxBloc>(context).add(value);
            }
          }
        );
      }
    );
  }
}