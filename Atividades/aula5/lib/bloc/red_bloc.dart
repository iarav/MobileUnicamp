import 'package:flutter_bloc/flutter_bloc.dart';

/*
 Estados e eventos são tipos
 */


/* Criando um modelo de estados */
class RedState {
  int amount;
  RedState({this.amount = 0});
}

/* Criando um modelo de eventos */
abstract class RedEvent{}

class MuitoRed extends RedEvent{}
class NormalRed extends RedEvent{}
class PoucoRed extends RedEvent{}
class SemRed extends RedEvent{}


class RedBloc extends Bloc<RedEvent, RedState>{
  RedBloc(RedState initialState) : super(initialState) {
    on<SemRed>((event, emit) => emit(RedState(amount: 0)));
    on<PoucoRed>((event, emit) => emit(RedState(amount: 50)));
    on<NormalRed>((event, emit) => emit(RedState(amount: 150)));
    on<MuitoRed>((event, emit) => emit(RedState(amount: 255)));
  }
}