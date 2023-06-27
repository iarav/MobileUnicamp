// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../bloc/dataBloqueada/dataBloqueada_bloc.dart';
import '../../bloc/dataBloqueada/dataBloqueada_event.dart';
import '../../bloc/bloc_state.dart';
import '../../model/datasBloqueadas.dart';

class AdmBloquearData extends StatefulWidget {
  const AdmBloquearData({super.key});

  @override
  State<AdmBloquearData> createState() => _AdmBloquearDataState();
}

class _AdmBloquearDataState extends State<AdmBloquearData> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final DataBloqueada data = DataBloqueada("");
  StreamSubscription<BlocState>? _blocSubscription;

  final _boxReservasCanceladas = Hive.box('reservas_canceladas');
  List<Map<String, dynamic>> _items = [];

  void _refreshListView() {
  if(!mounted){
      return;
    }
    setState(() {
      _items = _boxReservasCanceladas.values
          .map<Map<String, dynamic>>((dynamic item) => {
                'id': item['id'],
                'data': item['data'],
              })
          .toList();
    });
    //print("Os valores da boxReservas são:${_boxReservasCanceladas.values}");
    //print("Os valores da list são:${_items}");
  }

  void reloadData() async {
    _boxReservasCanceladas.clear();
    if (!mounted) {
      return;
    }
    final bloc = DataBloqueadaBloc(context);

    bloc.add(GetAllDataBloqueadaEvent());

    // Escute o estado do bloco
    bloc.stream.listen((state) async {
      if (state is LoadedState) {
        // Atualize a lista _items com os dados do estado LoadedState
        List<Map<String, dynamic>> itemsInicial = [];
        if (state.dados != null) {
          for (var value in state.dados!.values) {
            if (value is Map<String, dynamic>) {
              itemsInicial.add({
                'id': value['id'],
                'data': value['data'],
              });
            }
          }
          await _boxReservasCanceladas.addAll(itemsInicial);
        }
        _refreshListView();
      }
    });
  }

  @override
  void initState() {
    _boxReservasCanceladas.clear();
    reloadData();
    _refreshListView();
    super.initState();
  }

  Future<void> _addListBox(dynamic data, dynamic id) async {
    await _boxReservasCanceladas.add({
      'id': id,
      'data': data,
    });
    _refreshListView();
  }

  Widget _blocBuilder(dynamic index) {
    return BlocBuilder<DataBloqueadaBloc, BlocState>(builder: (context, state) {
      if (state is LoadedState || state is InicialState) {
        return Card(
          color: const Color.fromARGB(90, 180, 0, 0),
          child: ListTile(
            title: Text(_items[index]['data'] ?? '01/01/2000'),
            trailing: ElevatedButton(
              onPressed: () async {
                final bloc = context.read<DataBloqueadaBloc>();
                final dataId = index < _items.length ? _items[index]['id'] : '';

                bloc.add(DeleteDataBloqueadaEvent(dataId));

                await _boxReservasCanceladas.deleteAt(index);
                _refreshListView();
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: const Color.fromARGB(190, 214, 100, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Desbloquear',
                style: TextStyle(color: Color.fromARGB(255, 92, 0, 12)),
              ),
            ),
          ),
        );
      } else if (state is ErrorState) {
        return Card(
          child: ListTile(
            title: Text(state.message),
            trailing: ElevatedButton(
              onPressed: () async {
                BlocProvider.of<DataBloqueadaBloc>(context)
                    .add(GetAllDataBloqueadaEvent());
                _refreshListView();
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: const Color.fromARGB(189, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Tentar novamente',
                style: TextStyle(color: Color.fromARGB(190, 214, 100, 100)),
              ),
            ),
          ),
        );
      } else {
        return const Center(
          child: Text('Estado inválido'),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "SELECIONAR A DATA A SER BLOQUEADA:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            "Obs: datas bloqueadas impedem os usuários de reservar nesse dia",
            style: TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: SizedBox(
                    width: 210,
                    child: textForm(),
                  ),
                ),
                botaoBloquear(),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          //O expanded diz que o listView ocupará todo o resto da tela, ele é necessário
          Expanded(child: BlocBuilder<DataBloqueadaBloc, BlocState>(
              builder: (context, state) {
            return _items.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: ((state is LoadingState) ||
                            (state is InicialState && _items.isEmpty))
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: (_items.length),
                            itemBuilder: (context, index) {
                              return _blocBuilder(index);
                            },
                          ),
                  )
                : const Text('Nenhum dado disponível.');
          })),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
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

  Widget botaoBloquear() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          data.setData(_dateController.text);
          final bloc = context.read<DataBloqueadaBloc>();

          // Cancelar o StreamSubscription anterior, se existir
          _blocSubscription?.cancel();

          bloc.add(InsertDataBloqueadaEvent(data));

          bool jaExiste = false;
          String idIndexJaExistente = "";
          for (int i = 0; i < _items.length; i++) {
            if (_items[i]['data'] == data.data) {
              jaExiste = true;
              idIndexJaExistente = _items[i]['id'];
              break;
            }
          }

          if (jaExiste) {
            showDialogDataJaBloqueada(data, idIndexJaExistente);
          } else {
            _blocSubscription = bloc.stream.listen((state) async {
              if (state is LoadedState) {
                reloadData();
              }
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(230, 196, 0, 33),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        "Bloquear",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
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

  void showDialogDataJaBloqueada(DataBloqueada data, String idIndex) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Text(
                'Essa data já está bloqueada! Você deseja escolher outra data?',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await cancelarBloqueio(data);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialogEscolherNovaData(data, idIndex);
                    },
                    child: const Text('Sim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogEscolherNovaData(DataBloqueada data, String idIndex) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Text(
                'Selecione a nova data a ser bloqueada: ',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              textForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await cancelarBloqueio(data);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_dateController.text != data.data) {
                        data.data = _dateController.text;
                        Navigator.pop(context);
                        atualizarDataBloqueio(idIndex);
                      }
                    },
                    child: const Text('Bloquear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void alterarDataEscolhida() {}

  Future cancelarBloqueio(DataBloqueada data) async {
    final bloc = context.read<DataBloqueadaBloc>();
    return bloc.add(DeleteDataBloqueadaEvent(data.id));
  }

  Future atualizarDataBloqueio(dynamic hash) async {
    _blocSubscription?.cancel();
    final bloc = context.read<DataBloqueadaBloc>();
    bloc.add(UpdateDataBloqueadaEvent(data.id, data));
    _blocSubscription = bloc.stream.listen((state) async {
      if (state is LoadedState) {
        reloadData();
      }
    });
    return _blocSubscription;
  }
}
