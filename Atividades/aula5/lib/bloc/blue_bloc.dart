import 'package:flutter_bloc/flutter_bloc.dart';

/*
 Estados e eventos são tipos
 */


/* Criando um modelo de estados */
class BlueState {
  int amount;
  BlueState({this.amount = 0});
}

/* Criando um modelo de eventos */
abstract class BlueEvent{}

class MuitoBlue extends BlueEvent{}
class NormalBlue extends BlueEvent{}
class PoucoBlue extends BlueEvent{}
class SemBlue extends BlueEvent{}


class BlueBloc extends Bloc<BlueEvent, BlueState>{
  BlueBloc(BlueState initialState) : super(initialState) {
    on<SemBlue>((event, emit) => emit(BlueState(amount: 0)));
    on<PoucoBlue>((event, emit) => emit(BlueState(amount: 50)));
    on<NormalBlue>((event, emit) => emit(BlueState(amount: 150)));
    on<MuitoBlue>((event, emit) => emit(BlueState(amount: 255)));
  }
}