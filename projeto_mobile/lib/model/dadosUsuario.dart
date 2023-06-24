// ignore: file_names
class DadosUsuario {
  String id = "";
  String nome = "";
  String cpf = "";
  String email = "";
  String telefone = "";
  String senha = "";
  String fotoUrl = "";

  toMap() {
    return {
      "id": id,
      "nome": nome,
      "cpf": cpf,
      "email": email,
      "telefone": telefone,
      "senha": senha,
      "fotoUrl": fotoUrl
    };
  }

  converterParaDadosUsuario(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados['nome'];
    cpf = dados['cpf'];
    email = dados['email'];
    telefone = dados['telefone'];
    senha = dados['senha'];
    fotoUrl = dados['fotoUrl'];
  }
}
