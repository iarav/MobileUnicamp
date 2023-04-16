import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/blocs/tema_event.dart';
import 'package:flutter_application_1/blocs/tema_state.dart';

class TemaBloc extends Bloc<TemaEvent, TemaState> {
  TemaBloc() : super(TemaInitial()) {
    
    on<TemaInitialEvent>((event, emit){
        emit(TemaInitial());
      }
    );

    on<TemaChangeEvent>((event, emit){
        emit(TemaChange());
      }
    );
  }
}