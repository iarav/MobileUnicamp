import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/reserva.dart';

class RestReservasProvider {
  static RestReservasProvider helper = RestReservasProvider._createInstance();

  RestReservasProvider._createInstance();

  String baseUrl =
      "https://churrascaria-mobile-default-rtdb.firebaseio.com/reservas";
  
  Future<Map<String, dynamic>?> getAllReservas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl.json'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to retrieve data from RestReservasProvider'};
      }
    } catch (e) {
      print("ERRO: getAllReservas -> $e");
      return {'error': 'Failed to retrieve data from RestReservasProvider'};
    }
  }

  Future<Map<String, dynamic>> getReserva(dynamic id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id.json'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to retrieve data from RestReservasProvider'};
      }
    } catch (e) {
      print("ERRO: getReserva -> $e");
      return {'error': 'Failed to retrieve data from RestReservasProvider'};
    }
  }

  Future<String> insertReserva(Reserva reserva) async {
    final response = await http.post(
      Uri.parse('$baseUrl.json'),
      body: jsonEncode(reserva.toMap()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final novaChave = responseData['name'];
      //adiciona o HASH gerado pelo Firebase como id do objeto, é preciso dar um update para atualizar o id
      reserva.setId(novaChave);

      final completer = Completer<String>();

      updateReserva(reserva.id, reserva).then((_) {
        completer.complete(novaChave);
      }).catchError((error) {
        completer.completeError(error);
      });

      return completer.future;
    } else {
      throw Exception('Failed to post data to Firebase from RestReservasProvider');
    }
  }

  Future<void> updateReserva(String id, Reserva reserva) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id.json'),
      body: jsonEncode(reserva.toMap()),
    );

    if (response.statusCode != 200) {
      print("ERRO -> update data bloqueada");
      throw Exception('Failed to update data in Firebase from RestReservasProvider');
    }
  }

  Future<void> deleteReserva(dynamic id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data from Firebase from RestReservasProvider');
    }
  }
}