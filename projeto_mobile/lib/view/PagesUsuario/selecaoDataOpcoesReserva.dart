// ignore_for_file: library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/bloc_state.dart';
import '../../bloc/dataBloqueada/dataBloqueada_bloc.dart';
import '../../bloc/dataBloqueada/dataBloqueada_event.dart';
import '../../model/routes.dart';

class SelecaoData extends StatefulWidget {
  const SelecaoData({super.key});

  @override
  _SelecaoDataState createState() => _SelecaoDataState();
}

class _SelecaoDataState extends State<SelecaoData> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  late bool estaDisponivel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text(
              "Verifique aqui se a data\ndesejada está disponível:",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: SizedBox(
                width: 210,
                child: textForm(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async => {
                if (_selectedDate != null)
                  {
                    estaDisponivel = await verificarDisponibilidade(
                        DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                    if (estaDisponivel)
                      {
                        print("Disponível"),
                        dialogDisponibilidade(true),
                      }
                    else
                      {
                        print("Não está disponível"),
                        dialogDisponibilidade(false),
                      }
                  }
                else
                  {
                    print("Data não selecionada"),
                    dialogDisponibilidade(null),
                  }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 84,
                      174), // Define / Define a cor do texto do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ), // Define o raio dos cantos do botão
                  padding: const EdgeInsets.fromLTRB(25, 13, 25, 13)),
              child: const Text(
                'Verificar',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formattedDate = formatter.format(picked);
      setState(() {
        _selectedDate = picked;
        _dateController.text = formattedDate;
      });
    }
  }

  Widget textForm() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: '00/00/0000',
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Campo obrigatório.';
        }
        return null;
      },
      onTap: () {
        _selectDate(context);
      },
    );
  }

  Future<String?> dialogDisponibilidade(bool? disponivel) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              (disponivel == true)
                  ? //se disponivel faça
                  Text(
                      'A data: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} está disponível para reserva!',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : (disponivel == false)
                      ? //senão faça
                      const Text(
                          'A data está indisponível!\nSelecione outra data.',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const Text(
                          'Selecione uma data!',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (disponivel == true)
                    ? //se disponivel faça
                    [
                        TextButton(
                          onPressed: () {
                            _selectedDate = null;
                            _dateController.text = '';
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.fazerReserva, //define your route name
                              arguments: _selectedDate, //pass the arguments
                            );
                          },
                          child: const Text('Fazer Reserva'),
                        )
                      ]
                    : // senão faça
                    [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> verificarDisponibilidade(dataParaVerificar) async {
    final blocReservasBloqueadas = context.read<DataBloqueadaBloc>();
    List<Map<String, dynamic>> datasNaoDisponiveis = [];

    late bool disponivel;

    StreamSubscription? bloqueadasSubscription;

    Completer<bool> meuCompleter = Completer<bool>();

          blocReservasBloqueadas.add(GetDatasIndisponiveisEvent());
          bloqueadasSubscription =
              blocReservasBloqueadas.stream.listen((state) async {
            if (state is LoadedState) {
              if (state.dados != null) {
                for (var value in state.dados!.values) {
                  if (value is Map<String, dynamic>) {
                    datasNaoDisponiveis.add({
                      'datas': value['dataIndisponivel'],
                    });
                  }
                }
              }
            }
            if (bloqueadasSubscription != null && datasNaoDisponiveis.isNotEmpty) {
              print("DATAS INDISPONÍVEIS: ");
              print(datasNaoDisponiveis);

              //VERIFICA SE A DATA ESTÁ OU NÃO DISPONÍVEL
              bool dataEstaDisponivel = datasNaoDisponiveis.any((map) {
                String data = map['datas'] as String;
                return data == dataParaVerificar;
              });
              disponivel = !dataEstaDisponivel;

              if (!meuCompleter.isCompleted) {
                meuCompleter.complete(disponivel);
              }
            }
          });

    await meuCompleter.future;
    if (meuCompleter.isCompleted) {
      return disponivel;
    } else {
      throw Exception('Erro ao obter a disponibilidade');
    }
  }
}
