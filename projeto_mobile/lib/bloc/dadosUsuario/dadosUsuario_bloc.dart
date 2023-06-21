import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/rest_usuario_provider.dart';
import 'dadosUsuario_event.dart';
import '../bloc_state.dart';

class DadosUsuarioBloc extends Bloc<DadosUsuarioEvent, BlocState> {
  DadosUsuarioBloc(BuildContext context) : super(InicialState()) {
    on<GetAllDadosUsuarioEvent>(getAllEvent);
    on<InsertDadosUsuarioEvent>(submitEvent);
    on<UpdateDadosUsuarioEvent>(updateRequest);
    on<DeleteDadosUsuarioEvent>(deleteEvent);
    on<LoginDadosUsuarioEvent>(loginEvent);
  }

  Future<void> getAllEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final data =
          await RestUsuarioProvider.helper.getDadosUsuario(event.usuarioId);
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: getAllEvent -> $e");
      emit(ErrorState('Failed to getAll data to Firebase from bloc'));
    }
  }

  Future<void> submitEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      final id =
          await RestUsuarioProvider.helper.insertDadosUsuario(event.data);
      final data = await RestUsuarioProvider.helper.getDadosUsuario(id);
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: submitEvent -> $e");
      emit(ErrorState('Failed to post data to Firebase from bloc'));
    }
  }

  Future<void> updateRequest(event, Emitter emit) async {
    emit(LoadingState());
    try {
      await RestUsuarioProvider.helper.updateDadosUsuario(
          event.idAntigaDadosUsuario, event.novaDadosUsuario);
      final data = await RestUsuarioProvider.helper
          .getDadosUsuario(event.idAntigaDadosUsuario);
      emit(LoadedState(data));
    } catch (e) {
      print("ERRO: updateRequest -> $e");
      emit(ErrorState('Failed to update data to Firebase from bloc'));
    }
  }

  Future<void> deleteEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      await RestUsuarioProvider.helper
          .getDadosUsuario(event.usuarioId)
          .then((data) async {
        await RestUsuarioProvider.helper.deleteDadosUsuario(event.usuarioId);
        emit(LoadedState(data));
      });
    } catch (e) {
      print("ERRO: deleteEvent -> $e");
      emit(ErrorState('Failed to delete data to Firebase from bloc'));
    }
  }

  Future<void> loginEvent(event, Emitter emit) async {
    emit(LoadingState());
    try {
      await RestUsuarioProvider.helper
          .login(event.cpf, event.senha)
          .then((data) async {
        await RestUsuarioProvider.helper.login(event.cpf, event.senha);
        emit(LoadedState(data));
      });
    } catch (e) {
      print("ERRO: loginEvent -> $e");
      emit(ErrorState('Failed to delete data to Firebase from bloc'));
    }
  }
}
