class Reserva{
  String id = "";
  String nome = "";
  String telefone = "";
  String data = "";
  String qntPessoas = "";
  String combo = "";
  String preco = "";

  Reserva(this.nome, this.telefone, this.data, this.qntPessoas, this.combo, this.preco);

  setId(String id){
    this.id = id;
  }

  toMap() {
    return {
      "nome": nome,
      "telefone": telefone,
      "data": data,
      "qntPessoas": qntPessoas,
      "combo": combo,
      "preco": preco,
    };
  }
}

