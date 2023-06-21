// ignore: file_names

abstract class BlocState {}

class InicialState extends BlocState {}

class LoadingState extends BlocState {}

class LoadedState extends BlocState {
  final Map<String, dynamic>? dados;
  LoadedState(this.dados);
}

class ErrorState extends BlocState {
  final String message;
  ErrorState(this.message);
}
