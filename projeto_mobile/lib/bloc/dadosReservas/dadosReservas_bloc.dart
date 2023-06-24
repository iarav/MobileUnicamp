import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_state.dart';
import 'dadosReservas_event.dart';

class DadosReservasBloc extends Bloc<DadosReservasEvent, BlocState> {
  DadosReservasBloc(BuildContext context) : super(InicialState()) {
    on<GetAllDadosReservasEvent>(getAllEvent);
    // on<InsertDadosReservasEvent>();
    // on<UpdateDadosReservasEvent>();
    // on<DeleteDadosReservasEvent>();
  }
  Future<void> getAllEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final data = {'dataReserva': 'teste dataReserva reserva'};
      
      //o emit levará um Map com todos os dados
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: getAllEvent -> $e");
      emit(ErrorState('Failed to get reservas data in Firebase from bloc'));
    }
  }
}