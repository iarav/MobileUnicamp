import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/rest_reservas_provider.dart';
import '../bloc_state.dart';
import 'dadosReservas_event.dart';

class DadosReservasBloc extends Bloc<DadosReservasEvent, BlocState> {
  DadosReservasBloc(BuildContext context) : super(InicialState()) {
    on<GetAllDadosReservasEvent>(getReservasEvent);
    on<InsertDadosReservasEvent>(submitReservaEvent);
    on<DeleteDadosReservasEvent>(deleteReservasEvent);
  }

  Future<void> getReservasEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final data = await RestReservasProvider.helper.getAllReservas();
      //o emit levará um Map com todos os dados
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: getAllEvent -> $e");
      emit(ErrorState('Failed to get reservas data in Firebase from bloc'));
    }
  }

  Future<void> submitReservaEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final id = await RestReservasProvider.helper.insertReserva(event.data);
      final data = await RestReservasProvider.helper.getReserva(id);
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: submitEvent -> $e");
      emit(ErrorState('Failed to post data to Firebase from bloc'));
    }
  }

  Future<void> deleteReservasEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      await RestReservasProvider.helper
          .getReserva(event.dataId)
          .then((data) async {
        await RestReservasProvider.helper.deleteReserva(event.dataId);
        emit(LoadedState(data));
      });
    } catch (e) {
      print("ERRO: deleteEvent -> $e");
      emit(ErrorState('Failed to delete data to Firebase from bloc'));
    }
  }
}