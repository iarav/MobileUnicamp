// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc_state.dart';
import '../../bloc/dadosReservas/dadosReservas_bloc.dart';
import '../../bloc/dadosReservas/dadosReservas_event.dart';
import '../../model/hive_reservas.dart';

class MinhasReservas extends StatefulWidget {
  const MinhasReservas({super.key});

  @override
  State<MinhasReservas> createState() => _MinhasReservasState();
}

class _MinhasReservasState extends State<MinhasReservas> {
  final HiveReservas hive_reservas = HiveReservas();

  @override
  void initState() {
    hive_reservas.boxReservas.clear();
    hive_reservas.reloadData(context, this);
    hive_reservas.refreshListView(this);
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
        itemCount: (hive_reservas.items.length),
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
                  "${hive_reservas.items[index]['nome']} - ${hive_reservas.items[index]['telefone']}\n${hive_reservas.items[index]['dataReserva']} - ${hive_reservas.items[index]['qntPessoas']} pessoas\n${hive_reservas.items[index]['combo']} - R\$${hive_reservas.items[index]['preco']}",
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
                final idReserva = index < hive_reservas.items.length ? hive_reservas.items[index]['id'] : '';
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
                    await hive_reservas.boxReservas.deleteAt(index);
                    hive_reservas.refreshListView(this);
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