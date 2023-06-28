import '../../model/datasBloqueadas.dart';

abstract class DataBloqueadaEvent {}

class GetAllDataBloqueadaEvent extends DataBloqueadaEvent {}

class GetDatasIndisponiveisEvent extends DataBloqueadaEvent {}

class InsertDataBloqueadaEvent extends DataBloqueadaEvent {
  final DataBloqueada data;
  InsertDataBloqueadaEvent(this.data);
}

class UpdateDataBloqueadaEvent extends DataBloqueadaEvent {
  final String idAntigaDataBloqueada;
  final DataBloqueada novaDataBloqueada;
  UpdateDataBloqueadaEvent(this.idAntigaDataBloqueada, this.novaDataBloqueada);
}

class DeleteDataBloqueadaEvent extends DataBloqueadaEvent {
  final String dataId;
  DeleteDataBloqueadaEvent(this.dataId);
}
