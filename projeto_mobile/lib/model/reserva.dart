class Reserva{
  String id = "";
  String cpfUsuario = "";
  String nome = "";
  String telefone = "";
  String qntPessoas = "";
  String? combo;
  String preco = "";
  String dataReserva = "";

  // Reserva(this.nome, this.telefone, this.data, this.qntPessoas, this.combo, this.preco);
  Reserva();

  setId(String id){
    this.id = id;
  }

  toMap() {
    return {
      "id": id,
      "cpfUsuario": cpfUsuario,
      "nome": nome,
      "telefone": telefone,
      "qntPessoas": qntPessoas,
      "combo": combo,
      "preco": preco,
      "dataReserva": dataReserva
    };
  }
}

