import 'package:flutter_bloc/flutter_bloc.dart';

class CheckBoxBloc extends Bloc<bool, bool>{
  CheckBoxBloc():super(false){
    on<bool>((event,emit) => emit(event),);
  }
}