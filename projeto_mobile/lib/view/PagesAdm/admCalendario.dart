// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/bloc_state.dart';
import '../../bloc/dadosReservas/dadosReservas_bloc.dart';
import '../../bloc/dadosReservas/dadosReservas_event.dart';
import '../../bloc/dadosUsuario/dadosUsuario_bloc.dart';
import '../../bloc/dadosUsuario/dadosUsuario_event.dart';
import '../../model/dadosUsuario.dart';
import '../../model/listViewReservas.dart';

class AdmCalendario extends StatefulWidget {
  const AdmCalendario({super.key});

  @override
  State<AdmCalendario> createState() => _AdmCalendarioState();
}

class _AdmCalendarioState extends State<AdmCalendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String diaSelecionado = "";

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
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 15),
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
                diaSelecionado =
                    "${focusedDay.day}/${focusedDay.month}/${focusedDay.year}";
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            firstDay: DateTime.now(), // define o primeiro dia disponível
            lastDay:
                DateTime.utc(2050, 12, 31), // define o último dia disponível
          ),
          Expanded(
            child: _dadosUsuarioCadastro.cpf != ""
                ? BlocBuilder<DadosReservasBloc, BlocState>(
                    builder: (context, state) {
                    if (diaSelecionado == "") {
                      return const Center(
                        child: Text("Nenhum dia Selecionado."),
                      );
                    } else {
                      print("Dia selecionado: ${diaSelecionado}");
                      return ListViewReservas(
                          cpf: _dadosUsuarioCadastro.cpf,
                          calendario: diaSelecionado);
                    }
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
      ),
    );
  }
}
