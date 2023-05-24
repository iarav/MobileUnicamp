// ignore: file_names

abstract class DataBloqueadaState {}

class InicialState extends DataBloqueadaState {}

class LoadingState extends DataBloqueadaState {}

class LoadedState extends DataBloqueadaState {
  final Map<String, dynamic> dataBloqueada;
  LoadedState(this.dataBloqueada);
}

class ErrorState extends DataBloqueadaState {
  final String message;
  ErrorState(this.message);
}
