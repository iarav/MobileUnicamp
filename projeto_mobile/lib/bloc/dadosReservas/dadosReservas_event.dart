// ignore: file_names
import '../../model/reserva.dart';

abstract class DadosReservasEvent {}

class GetAllDadosReservasEvent extends DadosReservasEvent {}

class InsertDadosReservasEvent extends DadosReservasEvent {
  final Reserva reserva;
  InsertDadosReservasEvent(this.reserva);
}

class UpdateDadosReservasEvent extends DadosReservasEvent {
}

class DeleteDadosReservasEvent extends DadosReservasEvent {
}