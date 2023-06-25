import 'package:hive/hive.dart';

import '../bloc/bloc_state.dart';
import '../bloc/dadosReservas/dadosReservas_bloc.dart';
import '../bloc/dadosReservas/dadosReservas_event.dart';

class HiveReservas {
  final boxReservas = Hive.box('reservas');
  List<Map<String, dynamic>> items = [];

  void refreshListView(widgetState) {
    if (!widgetState.mounted) {
      return;
    }
    widgetState.setState(() {
      items = boxReservas.values
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

  void reloadData(context, widgetState) async {
    boxReservas.clear();
    final bloc = DadosReservasBloc(context);

    bloc.add(GetAllDadosReservasEvent());

    // Escute o estado do bloco
    bloc.stream.listen((state) async {
      if (state is LoadedState) {
        // Atualize a lista "items" com os dados do estado LoadedState
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
          await boxReservas.addAll(itemsInicial);
        }
        refreshListView(widgetState);
      }
    });
  }
}
