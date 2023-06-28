// ignore: file_names
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
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
  LinkedHashMap<DateTime, List<DateTime>>? _groupedEvents;

  final Box _textformValues = Hive.box("textform_values");
  String loggedUserId = "";
  final DadosUsuario _dadosUsuarioCadastro = DadosUsuario();

  List<DateTime> _markedDates = [];

  int getHashCOde(DateTime key) {
    return key.day * 10000000 + key.month * 102102 + key.year;
  }

  _groupEvents(List<DateTime> datas) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCOde);
    for (var data in _markedDates) {
      if (_groupedEvents![data] == null) _groupedEvents![data] = [];
      _groupedEvents![data]!.add(data);
    }
  }

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

  List<dynamic> _getEventsForDay(DateTime date) {
    return _groupedEvents?[date] ?? [];
  }

  @override
  void initState() {
    loggedUserId = _textformValues.get('loggedUserId');
    diaSelecionado = DateFormat('dd/MM/yyyy').format(DateTime.now());
    getDadosUsuario(this);
    getDatas();
    super.initState();
  }

  void getDatas() async {
    final bloc = DadosReservasBloc(context);

    bloc.add(GetAllDadosReservasEvent());

    bloc.stream.listen((state) async {
      if (state is LoadedState) {
        List<DateTime> itemsInicial = [];
        if (state.dados != null) {
          for (var value in state.dados!.values) {
            if (value is Map<String, dynamic>) {
              DateTime newDate =
                  DateFormat('dd/MM/yyyy').parse(value['dataReserva']);
              if (!itemsInicial.contains(newDate)) {
                itemsInicial.add(newDate);
              }
            }
          }
        }
        _markedDates = itemsInicial;
        _groupEvents(_markedDates);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 15),
          TableCalendar(
            eventLoader: _getEventsForDay,
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
                diaSelecionado = DateFormat('dd/MM/yyyy').format(_focusedDay);
                //diaSelecionado =
                //    "${focusedDay.day}/${focusedDay.month}/${focusedDay.year}";
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
