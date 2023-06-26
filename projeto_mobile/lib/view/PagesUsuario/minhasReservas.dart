// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../bloc/bloc_state.dart';
import '../../bloc/dadosUsuario/dadosUsuario_bloc.dart';
import '../../bloc/dadosUsuario/dadosUsuario_event.dart';
import '../../model/dadosUsuario.dart';
import '../../model/listViewReservas.dart';

class MinhasReservas extends StatefulWidget {
  const MinhasReservas({super.key});

  @override
  State<MinhasReservas> createState() => _MinhasReservasState();
}

class _MinhasReservasState extends State<MinhasReservas> {
  final Box _textformValues = Hive.box("textform_values");
  String loggedUserId = "";
  final DadosUsuario _dadosUsuarioCadastro = DadosUsuario();

  void getDadosUsuario(stateWidget) async {
    if (!mounted) {
      return;
    }
    final bloc = DadosUsuarioBloc(context);
    bloc.add(GetAllDadosUsuarioEvent(loggedUserId));
    bloc.stream.listen((state) async {
      if (state is LoadedState) {
        Map<String, dynamic>? usuario = state.dados;
        if (usuario != null) {
          setState(() {
            _dadosUsuarioCadastro.converterParaDadosUsuario(usuario);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Não foi possivel recuperar os dados do usuário.')));
        }
      }
    });
  }

  @override
  void initState() {
    loggedUserId = _textformValues.get('loggedUserId');
    getDadosUsuario(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _dadosUsuarioCadastro.cpf != ""
              ? BlocBuilder<DadosUsuarioBloc, BlocState>(
                  builder: (context, state) {
                  return ListViewReservas(cpf: _dadosUsuarioCadastro.cpf);
                })
              : const SizedBox(
                  height: 50.0, 
                  width: 50.0,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 209, 150, 92)),
                  )),
                ),
        ),
      ],
    );
  }
}
