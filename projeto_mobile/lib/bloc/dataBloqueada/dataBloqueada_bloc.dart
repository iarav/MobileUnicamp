import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/rest_data_provider.dart';
import 'dataBloqueada_event.dart';
import 'dataBloqueada_state.dart';

class DataBloqueadaBloc extends Bloc<DataBloqueadaEvent, DataBloqueadaState> {
  DataBloqueadaBloc(BuildContext context) : super(InicialState()) {
    on<GetAllDataBloqueadaEvent>(getAllEvent);
    on<InsertDataBloqueadaEvent>(submitEvent);
    on<UpdateDataBloqueadaEvent>(updateRequest);
    on<DeleteDataBloqueadaEvent>(deleteEvent);
  }

  Future<void> getAllEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final data = await RestDataProvider.helper.getAllDataBloqueada();
      //o emit levará um Map com todos os dados
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: getAllEvent -> $e");
      emit(ErrorState('Failed to getAll data to Firebase from bloc'));
    }
  }

  Future<void> submitEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final id = await RestDataProvider.helper.insertDataBloqueada(event.data);
      final data = await RestDataProvider.helper.getDataBloqueada(id);
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: submitEvent -> $e");
      emit(ErrorState('Failed to post data to Firebase from bloc'));
    }
  }

  Future<void> updateRequest(event, Emitter emit) async {
    emit(LoadingState());
    try {
      await RestDataProvider.helper.updateDataBloqueada(
          event.idAntigaDataBloqueada, event.novaDataBloqueada);
      final data = await RestDataProvider.helper
          .getDataBloqueada(event.idAntigaDataBloqueada);
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: updateRequest -> $e");
      emit(ErrorState('Failed to update data to Firebase from bloc'));
    }
  }

  Future<void> deleteEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      await RestDataProvider.helper
          .getDataBloqueada(event.dataId)
          .then((data) async {
        await RestDataProvider.helper.deleteDataBloqueada(event.dataId);
        emit(LoadedState(data));
      });
    } catch (e) {
      print("ERRO: deleteEvent -> $e");
      emit(ErrorState('Failed to delete data to Firebase from bloc'));
    }
  }
}
