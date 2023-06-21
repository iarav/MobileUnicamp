import '../../model/dadosUsuario.dart';

abstract class DadosUsuarioEvent {}

class GetAllDadosUsuarioEvent extends DadosUsuarioEvent {}

class InsertDadosUsuarioEvent extends DadosUsuarioEvent {
  final DadosUsuario data;
  InsertDadosUsuarioEvent(this.data);
}

class UpdateDadosUsuarioEvent extends DadosUsuarioEvent {
  final String idAntigaDadosUsuario;
  final DadosUsuario novaDadosUsuario;
  UpdateDadosUsuarioEvent(this.idAntigaDadosUsuario, this.novaDadosUsuario);
}

class DeleteDadosUsuarioEvent extends DadosUsuarioEvent {
  final String usuarioId;
  DeleteDadosUsuarioEvent(this.usuarioId);
}

class LoginDadosUsuarioEvent extends DadosUsuarioEvent {
  final String cpf;
  final String senha;
  LoginDadosUsuarioEvent(this.cpf, this.senha);
}
