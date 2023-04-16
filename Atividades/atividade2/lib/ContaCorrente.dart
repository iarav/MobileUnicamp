class Cliente{
  //atributos
  String _nome;
  int _idade;

  //construtor
  Cliente(this.nome, this.idade);

  //getters e setters
  String get nome => "$_nome";
  int get idade{
    return _idade;
  }

  set nome(n){
    List nome = n.split(" ");
    _nome = nome[0];
  }
  set idade(i){
    _idade = i;
  }
}