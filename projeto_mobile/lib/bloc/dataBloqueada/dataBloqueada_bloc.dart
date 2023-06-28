import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/rest_data_provider.dart';
import '../../provider/rest_reservas_provider.dart';
import 'dataBloqueada_event.dart';
import '../bloc_state.dart';

class DataBloqueadaBloc extends Bloc<DataBloqueadaEvent, BlocState> {
  DataBloqueadaBloc(BuildContext context) : super(InicialState()) {
    on<GetAllDataBloqueadaEvent>(getAllEvent);
    on<GetDatasIndisponiveisEvent>(getIndisponiveisEvent);
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

  Future<void> getIndisponiveisEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final datasBloqueadas = await RestDataProvider.helper.getAllDataBloqueada();
      final datasReservas = await RestReservasProvider.helper.getAllReservas();
      Map<String, dynamic>? datasNaoDisponiveis = {};

      for (var entry in datasReservas!.entries) {
        datasNaoDisponiveis.addAll({
          entry.key: {'dataIndisponivel': entry.value['dataReserva']}
        });
      }
      for (var entry in datasBloqueadas!.entries) {
        datasNaoDisponiveis.addAll({
          entry.key: {'dataIndisponivel': entry.value['data']}
        });
      }
      // print("datasNaoDisponiveis:");
      // print(datasNaoDisponiveis);
      //o emit levará um Map com todos os dados
      emit(LoadedState(datasNaoDisponiveis));
    } catch (e) {
      print("ERRO: getIndisponiveisEvent -> $e");
      emit(ErrorState('Failed to getIndisponiveis data to Firebase from bloc'));
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
