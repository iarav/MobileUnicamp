// ignore: file_names
class DadosUsuario {
  String id = "";
  String nome = "";
  String cpf = "";
  String email = "";
  String telefone = "";
  String senha = "";
  String confirmacaoSenha = "";

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
}
