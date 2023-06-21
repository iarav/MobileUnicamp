import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/dadosUsuario.dart';

import 'package:hive/hive.dart';

class RestUsuarioProvider {
  final Box _textformValues = Hive.box("textform_values");
  static RestUsuarioProvider helper = RestUsuarioProvider._createInstance();

  RestUsuarioProvider._createInstance();

  String baseUrl =
      "https://churrascaria-mobile-default-rtdb.firebaseio.com/usuarios";

  Future<Map<String, dynamic>> getAllUsuarios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl.json'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to retrieve data'};
      }
    } catch (e) {
      print("ERRO: getAllUsuarios -> $e");
      return {'error': 'Failed to retrieve data'};
    }
  }

  Future<Map<String, dynamic>> getDadosUsuario(dynamic id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id.json'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to retrieve data from Firebase');
        return {'error': 'Failed to retrieve data'};
      }
    } catch (e) {
      print("ERRO: getDadosUsuario -> $e");
      return {'error': 'Failed to retrieve data'};
    }
  }

  Future<String> insertDadosUsuario(DadosUsuario dadosUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl.json'),
      body: jsonEncode(dadosUsuario.toMap()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final novaChave = responseData['name'];
      //adiciona o HASH gerado pelo Firebase como id do objeto, é preciso dar um update para atualizar o id
      dadosUsuario.id = novaChave;

      final completer = Completer<String>();

      updateDadosUsuario(dadosUsuario.id, dadosUsuario).then((_) {
        completer.complete(novaChave);
      }).catchError((error) {
        completer.completeError(error);
      });

      return completer.future;
    } else {
      throw Exception('Failed to post data to Firebase');
    }
  }

  Future<void> updateDadosUsuario(String id, DadosUsuario dadosUsuario) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id.json'),
      body: jsonEncode(dadosUsuario.toMap()),
    );

    if (response.statusCode != 200) {
      print("ERRO -> updateDadosUsuario");
      throw Exception('Failed to update data in Firebase');
    }
  }

  Future<void> deleteDadosUsuario(dynamic id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data from Firebase from rest');
    }
  }

  Future<Map<String, dynamic>> login(String cpf, String senha) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl.json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Encontrar o usuário com base no CPF fornecido
        final usuario = data.values.firstWhere(
          (usuario) => usuario['cpf'] == cpf,
          orElse: () => null,
        );

        if (usuario != null) {
          if (usuario['senha'] == senha) {
            _textformValues.put('loggedUserId', usuario['id']);
            return {'message': 'Login efetuado com sucesso!'};
          } else {
            return {'error': 'Senha Incorreta.'};
          }
        } else {
          return {'error': 'CPF não encontrado.'};
        }
      } else {
        return {'error': 'Falha na conexão com o servidor.'};
      }
    } catch (e) {
      print("ERRO: login -> $e");
      return {'error': 'Falha na conexão com o servidor.'};
    }
  }
}
