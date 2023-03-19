class Cliente{
  String nome;
  
  Cliente(this.nome);
}

abstract class ContaCorrente{
  Cliente cliente;
  double saldo;
  
  ContaCorrente(this.cliente, this.saldo);
  
  @override
  String toString(){
    return "Cliente: ${cliente.nome}, saldo= ${saldo.toString()}";
  }
  int verificarTipo();
}

class ContaComum extends ContaCorrente{
  ContaComum(Cliente cliente, double saldo) : super(cliente, saldo);
  
  @override
  int verificarTipo(){
    print("Eu sou uma Conta Comum");
    return 1;
  }
}

class ContaEspecial extends ContaCorrente{
  double taxaDeJuros = 0.5;
  double limite = -100;
  ContaEspecial(Cliente cliente, double saldo) : super(cliente, saldo);
  void aplicaCorrecao(){
    saldo = saldo * (1+taxaDeJuros);
  }
  @override
  int verificarTipo(){
    print("Eu sou uma Conta Especial");
    return 2;
  }
}

class Banco{
  List conta;
  
  Banco(this.conta);
  
  @override
  String toString(){
    return "Contas nesse banco: ${conta.toString()}";
  }
  
  void tranferir(contaOrigem, contaDestino, valor){
    bool erro = false;
    if(contaOrigem.verificarTipo() == 2){
      if(contaOrigem.saldo <= contaOrigem.limite){
        print("Você atingiu seu limite de ${contaOrigem.limite}, transferência não efetuada. ");
        erro = true;
      }
    }else{
      if(contaOrigem.saldo < valor){
        print("Saldo Insuficiente");
        erro = true;
      }
    }
    if(!erro){
      contaOrigem.saldo -= valor;
      contaDestino.saldo += valor;
    }
  }
}

void main() {
  try{
    Cliente cliente = Cliente("Iara");
    ContaComum cm = ContaComum(cliente, 10);
    ContaEspecial ce = ContaEspecial(cliente, 300);
    
    // print(cm.toString());
    // print(ce.toString());
    
    
    Banco banco1 = Banco([cm, ce]);
    // print(banco1.toString());

    // banco1.tranferir(cm, ce, 20);
    // banco1.tranferir(cm, ce, 5);
    // print(ce.toString());
    // print(cm.toString());

    ContaEspecial ce2 = ContaEspecial(cliente, -100);
    banco1.tranferir(ce2, cm, 200);
    print(ce.toString());
    print(cm.toString());

  }catch(e){
    print(e);
  }
}