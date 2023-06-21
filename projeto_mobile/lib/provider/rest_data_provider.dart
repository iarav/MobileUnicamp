import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/datasBloqueadas.dart';

class RestDataProvider {
  static RestDataProvider helper = RestDataProvider._createInstance();

  RestDataProvider._createInstance();

  String baseUrl =
      "https://churrascaria-mobile-default-rtdb.firebaseio.com/datasBloqueadas";

  Future<Map<String, dynamic>?> getAllDataBloqueada() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl.json'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to retrieve data'};
      }
    } catch (e) {
      print("ERRO: getAllDataBloqueada -> $e");
      return {'error': 'Failed to retrieve data'};
    }
  }

  Future<Map<String, dynamic>> getDataBloqueada(dynamic id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id.json'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to retrieve data from Firebase');
        return {'error': 'Failed to retrieve data'};
      }
    } catch (e) {
      print("ERRO: getDataBloqueada -> $e");
      return {'error': 'Failed to retrieve data'};
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

      final completer = Completer<String>();

      updateDataBloqueada(dataBloqueada.id, dataBloqueada).then((_) {
        completer.complete(novaChave);
      }).catchError((error) {
        completer.completeError(error);
      });

      return completer.future;
    } else {
      throw Exception('Failed to post data to Firebase');
    }
  }

  Future<void> updateDataBloqueada(String id, DataBloqueada data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id.json'),
      body: jsonEncode(data.toMap()),
    );

    if (response.statusCode != 200) {
      print("ERRO -> update data bloqueada");
      throw Exception('Failed to update data in Firebase');
    }
  }

  Future<void> deleteDataBloqueada(dynamic id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data from Firebase from rest');
    }
  }
}
