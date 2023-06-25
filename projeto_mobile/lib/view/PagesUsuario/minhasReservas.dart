// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../bloc/bloc_state.dart';
import '../../bloc/dadosReservas/dadosReservas_bloc.dart';
import '../../bloc/dadosReservas/dadosReservas_event.dart';

class MinhasReservas extends StatefulWidget {
  const MinhasReservas({super.key});

  @override
  State<MinhasReservas> createState() => _MinhasReservasState();
}

class _MinhasReservasState extends State<MinhasReservas> {
  final _boxReservas = Hive.box('reservas');
  List<Map<String, dynamic>> _items = [];

  void _refreshListView() {
    setState(() {
      _items = _boxReservas.values
          .map<Map<String, dynamic>>((dynamic item) => {
                'id': item['id'],
                'nome': item['nome'],
                'telefone': item['telefone'],
                'qntPessoas': item['qntPessoas'],
                'combo': item['combo'],
                'preco': item['preco'],
                'dataReserva': item['dataReserva'],
              })
          .toList();
    });
  }

  void reloadData() async {
    _boxReservas.clear();
    final bloc = DadosReservasBloc(context);

    bloc.add(GetAllDadosReservasEvent());

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
                'nome': value['nome'],
                'telefone': value['telefone'],
                'qntPessoas': value['qntPessoas'],
                'combo': value['combo'],
                'preco': value['preco'],
                'dataReserva': value['dataReserva'],
              });
            }
          }
          await _boxReservas.addAll(itemsInicial);
        }
        _refreshListView();
      }
    });
  }

  @override
  void initState() {
    _boxReservas.clear();
    reloadData();
    _refreshListView();
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20,),
        Expanded(child: BlocBuilder<DadosReservasBloc, BlocState>(
            builder: (context, state) {
              return listaReservas();
            }
          )
        ),
      ],
    );
  }

  Widget listaReservas(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView.builder(
        itemCount: (_items.length),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2, // valor de elevação da sombra
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12.0), // borda arredondada
            ),
            color: const Color.fromARGB(255, 158, 177, 181),
            child: Column(children: [
              ListTile(
                title: Text(
                  "${_items[index]['nome']} - ${_items[index]['telefone']}\n${_items[index]['dataReserva']} - ${_items[index]['qntPessoas']} pessoas\n${_items[index]['combo']} - R\$${_items[index]['preco']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "inder",
                  ),
                ),
              ),
              ElevatedButton(
              onPressed: (){
                final idReserva = index < _items.length ? _items[index]['id'] : '';
                showDialog(
                  context: context,
                  builder: (BuildContext context) => dialogCancelarReserva(idReserva, index),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                     Color.fromARGB(255, 1, 29, 62),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text("Cancelar Reserva"),
              ),
            ]),
          );
        }
      )
    );
  }

  Widget dialogCancelarReserva(dynamic idReserva, dynamic index){
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Você tem certeza que deseja cancelar a reserva?',
              style: TextStyle( 
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final bloc = context.read<DadosReservasBloc>();
                    bloc.add(DeleteDadosReservasEvent(idReserva));
                    await _boxReservas.deleteAt(index);
                    _refreshListView();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar Reserva'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}