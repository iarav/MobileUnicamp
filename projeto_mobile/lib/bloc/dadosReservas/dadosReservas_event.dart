// ignore: file_names
import '../../model/reserva.dart';

abstract class DadosReservasEvent {}

class GetAllDadosReservasEvent extends DadosReservasEvent {}

class InsertDadosReservasEvent extends DadosReservasEvent {
  final Reserva data;
  InsertDadosReservasEvent(this.data);
}

class DeleteDadosReservasEvent extends DadosReservasEvent {
  final String dataId;
  DeleteDadosReservasEvent(this.dataId);
}