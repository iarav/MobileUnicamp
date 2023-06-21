// ignore: file_names
class DadosUsuario {
  String id = "";
  String nome = "";
  String cpf = "";
  String email = "";
  String telefone = "";
  String senha = "";

  toMap() {
    return {
      "id": id,
      "nome": nome,
      "cpf": cpf,
      "email": email,
      "telefone": telefone,
      "senha": senha
    };
  }

  converterParaDadosUsuario(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados['nome'];
    cpf = dados['cpf'];
    email = dados['email'];
    telefone = dados['telefone'];
    senha = dados['senha'];
  }
}
