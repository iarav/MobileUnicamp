import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/datasBloqueadas.dart';

class RestDataProvider {
  static RestDataProvider helper = RestDataProvider._createInstance();

  RestDataProvider._createInstance();

  String baseUrl =
      "https://churrascaria-mobile-default-rtdb.firebaseio.com/datasBloqueadas";

  Future<Map<String, dynamic>> getAllDataBloqueada() async {
    final response = await http.get(Uri.parse('$baseUrl.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve data from Firebase');
    }
  }

  Future<Map<String, dynamic>> getDataBloqueada(dynamic id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve data from Firebase');
    }
  }

  Future<String> insertDataBloqueada(DataBloqueada dataBloqueada) async {
  final response = await http.post(
    Uri.parse('$baseUrl.json'),
    body: jsonEncode(dataBloqueada.toMap()),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final novaChave = responseData['name'];
    //adiciona o HASH gerado pelo Firebase como id do objeto, é preciso dar um update para atualizar o id
    dataBloqueada.setId(novaChave);
    
    // Crie uma completer para sinalizar a conclusão do Future após a atualização do ID
    final completer = Completer<String>();
    
    // Chame a função de atualização e aguarde a conclusão antes de retornar o novo ID
    updateDataBloqueada(dataBloqueada, dataBloqueada).then((_) {
      completer.complete(novaChave);
    }).catchError((error) {
      completer.completeError(error);
    });
    
    return completer.future;
  } else {
    throw Exception('Failed to post data to Firebase');
  }
}


  Future<void> updateDataBloqueada(DataBloqueada antigaDataBloqueada,
      DataBloqueada novaDataBloqueada) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/${antigaDataBloqueada.id}.json'),
      body: jsonEncode(novaDataBloqueada.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update data in Firebase');
    }
  }

  Future<void> deleteDataBloqueada(dynamic id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/$id.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data from Firebase from rest');
    }
  }
}

//   // insertReserva(Reserva reserva) async {
//   //   _dio.post(
//   //     prefixUrl + suffixUrl,
//   //     data: reserva.toMap(),
//   //   );
//   // }

//   // updateReserva(String reservaId, Reserva reserva) async {
//   //   _dio.put(
//   //     prefixUrl + reservaId + suffixUrl,
//   //     data: reserva.toMap(),
//   //   );
//   // }

//   // deleteNote(String reservaId) async {
//   //   _dio.delete(
//   //     prefixUrl + reservaId + suffixUrl,
//   //   );
//   // }





// //Exemplo de chamar as classes
// final firebaseApi = FirebaseRestAPI('https://seu-projeto.firebaseio.com');
  
// // Obter dados
// final Reserva reserva = Reserva('Maria', '123', '00/00/0000', '100', 'normal', '300');
// dynamic result = await restProvider.insertReserva(reserva);
// print(result);

// // Enviar dados
// final newData = {'name': 'John', 'age': 25};
// await firebaseApi.postData('caminho-do-nodo.json', newData);

// // Atualizar dados
// final updatedData = {'name': 'John Doe', 'age': 26};
// await firebaseApi.updateData('caminho-do-nodo.json', updatedData);

// // Deletar dados
// await firebaseApi.deleteData('caminho-do-nodo.json');