// ignore: file_names
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/dadosReserva.dart';

class AdmCalendario extends StatefulWidget {
  const AdmCalendario({super.key});

  @override
  State<AdmCalendario> createState() => _AdmCalendarioState();
}

class _AdmCalendarioState extends State<AdmCalendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DadosReserva reservas = DadosReserva();

  List<bool> isCardEnabled = List<bool>.generate(7, (_) => true);
  List<Color> selectedCardColor =
      List<Color>.generate(7, (_) => const Color.fromARGB(255, 158, 177, 181));
  int selectedCardIndex = -1;
  List<String> textoBotao = List<String>.generate(7, (_) => "Cancelar Reserva");

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
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Center(
                    child: SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2, // valor de elevação da sombra
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // borda arredondada
                          ),
                          color: selectedCardColor[index],
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "${reservas.nome[index]} - ${reservas.telefone[index]}\n${reservas.data[index]} - ${reservas.qntPessoas[index]}  pessoas\n${reservas.combo[index]} - R\$${reservas.preco[index]}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "inder",
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: isCardEnabled[index]
                                    ? () {
                                        setState(() {
                                          selectedCardIndex = index;
                                          selectedCardColor[selectedCardIndex] =
                                              const Color.fromARGB(
                                                  150, 144, 10, 0);
                                          isCardEnabled[selectedCardIndex] =
                                              false;
                                          textoBotao[selectedCardIndex] =
                                              'RESERVA CANCELADA';
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 1, 29, 62),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(textoBotao[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
