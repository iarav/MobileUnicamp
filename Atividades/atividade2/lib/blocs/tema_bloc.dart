import 'package:atividade2/blocs/tema_event.dart';
import 'package:atividade2/blocs/tema_state.dart';
import 'package:bloc/bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeDark()){
    
    on<ThemeLightEvent>((event, emit){
        emit(ThemeLight());
      }
    );

    on<ThemeDarkEvent>((event, emit){
        emit(ThemeDark());
      }
    );
  }
}