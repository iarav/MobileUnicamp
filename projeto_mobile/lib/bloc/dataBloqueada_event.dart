import '../model/datasBloqueadas.dart';

abstract class DataBloqueadaEvent {}

class GetAllDataBloqueadaEvent extends DataBloqueadaEvent {}

class InsertDataBloqueadaEvent extends DataBloqueadaEvent {
  final DataBloqueada data;
  InsertDataBloqueadaEvent(this.data);
}

class UpdateDataBloqueadaEvent extends DataBloqueadaEvent {
  final DataBloqueada antigaData;
  final DataBloqueada novaData;
  UpdateDataBloqueadaEvent(this.antigaData, this.novaData);
}

class DeleteDataBloqueadaEvent extends DataBloqueadaEvent {
  final String dataId;
  DeleteDataBloqueadaEvent(this.dataId);
}
