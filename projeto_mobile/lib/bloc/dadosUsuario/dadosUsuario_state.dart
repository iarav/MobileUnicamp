// ignore: file_names

abstract class DadosUsuarioState {}

class InicialState extends DadosUsuarioState {}

class LoadingState extends DadosUsuarioState {}

class LoadedState extends DadosUsuarioState {
  final Map<String, dynamic> dadosUsuario;
  LoadedState(this.dadosUsuario);
}

class ErrorState extends DadosUsuarioState {
  final String message;
  ErrorState(this.message);
}
