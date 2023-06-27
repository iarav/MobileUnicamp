import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../bloc/bloc_state.dart';
import '../bloc/dadosReservas/dadosReservas_bloc.dart';
import '../bloc/dadosReservas/dadosReservas_event.dart';

class ListViewReservas extends StatefulWidget {
  final String cpf;
  final String? calendario; //essa variavel vai guardar a data do calendario. Caso nao seja a tela do calendario chamando, retorna null

  ListViewReservas({Key? key, required this.cpf, this.calendario})
      : super(key: key);
  @override
  State<ListViewReservas> createState() => _ListViewReservasState();
}

class _ListViewReservasState extends State<ListViewReservas> {
  // late String cpfUsuario = widget.cpf;
  // late String? dataCalendario = widget.calendario;
  late String? cpfUsuario;
  late String? dataCalendario;
  final _boxReservas = Hive.box('reservas');
  List<Map<String, dynamic>> _items = [];

  void _refreshListView() {
    if(!mounted){
      return;
    }
    setState(() {
      _items = _boxReservas.values
          .map<Map<String, dynamic>>((dynamic item) => {
                'id': item['id'],
                'cpfUsuario': item['cpfUsuario'],
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
                'cpfUsuario': value['cpfUsuario'],
                'nome': value['nome'],
                'telefone': value['telefone'],
                'qntPessoas': value['qntPessoas'],
                'combo': value['combo'],
                'preco': value['preco'],
                'dataReserva': value['dataReserva'],
              });
            }
          }
          if (cpfUsuario == "123456") {
            if(dataCalendario != null) {
              itemsInicial = itemsInicial.where((item) => item['dataReserva'] == dataCalendario).toList();
              await _boxReservas.addAll(itemsInicial);
            }
            else{
              //adiciona todos na _boxReservas 
              await _boxReservas.addAll(itemsInicial);
            }
          }
          else{
            // apenas itens iguais ao cpfUsuario são adicionados a _boxReservas
            itemsInicial = itemsInicial.where((item) => item['cpfUsuario'] == cpfUsuario).toList();
            await _boxReservas.addAll(itemsInicial);
          }
        }
        _refreshListView();
      }
    });
  }

  @override
  void initState() {
    cpfUsuario = widget.cpf;
    dataCalendario = widget.calendario;
    _boxReservas.clear();
    reloadData();
    _refreshListView();
    super.initState();
  }

  @override
  void didUpdateWidget(ListViewReservas oldWidget) {
    super.didUpdateWidget(oldWidget);
    cpfUsuario = widget.cpf;
    dataCalendario = widget.calendario;
    _boxReservas.clear();
    reloadData();
    _refreshListView();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: listaReservas(cpfUsuario, dataCalendario),
    );
  }

  Widget listaReservas(cpf, dataCalendario) {
    //USUÁRIO ADMINISTRADOR
    if (cpf == "123456") {
      print("items: $_items");
      print("administrador | dataCalendario: ${dataCalendario}");
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListView.builder(
              itemCount: (_items.length),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: Card(
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
                        onPressed: () {
                          final idReserva =
                              index < _items.length ? _items[index]['id'] : '';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                dialogCancelarReserva(idReserva, index),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 1, 29, 62),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text("Cancelar Reserva"),
                      ),
                    ]),
                  ),
                );
              }));
    }

    //USUÁRIO COMUM
    else {
      print("usuário comum");
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListView.builder(
              itemCount: (_items.length),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: Card(
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
                          "${_items[index]['dataReserva']} - ${_items[index]['qntPessoas']} pessoas\n${_items[index]['combo']} - R\$${_items[index]['preco']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "inder",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final idReserva =
                              index < _items.length ? _items[index]['id'] : '';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                dialogCancelarReserva(idReserva, index),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 1, 29, 62),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text("Cancelar Reserva"),
                      ),
                    ]),
                  ),
                );
              }));
    }
  }

  Widget dialogCancelarReserva(dynamic idReserva, dynamic index) {
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
