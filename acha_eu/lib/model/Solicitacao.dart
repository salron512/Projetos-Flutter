class Solicitacao{
  String _descricao;
  String _idSolicitante;
  String _categoria;
  String _nome;
  String _telefone;
  String _whatsapp;
  String _cidade;

  Solicitacao();
// ignore: unnecessary_getters_setters
  String get cidade => _cidade;
// ignore: unnecessary_getters_setters
  set cidade(String value) {
    _cidade = value;
  }
// ignore: unnecessary_getters_setters
  String get whatsapp => _whatsapp;
// ignore: unnecessary_getters_setters
  set whatsapp(String value) {
    _whatsapp = value;
  }
// ignore: unnecessary_getters_setters
  String get telefone => _telefone;
// ignore: unnecessary_getters_setters
  set telefone(String value) {
    _telefone = value;
  }
// ignore: unnecessary_getters_setters
  String get nome => _nome;
// ignore: unnecessary_getters_setters
  set nome(String value) {
    _nome = value;
  }
// ignore: unnecessary_getters_setters
  String get categoria => _categoria;
// ignore: unnecessary_getters_setters
  set categoria(String value) {
    _categoria = value;
  }
// ignore: unnecessary_getters_setters
  String get idSolicitante => _idSolicitante;
// ignore: unnecessary_getters_setters
  set idSolicitante(String value) {
    _idSolicitante = value;
  }
// ignore: unnecessary_getters_setters
  String get descricao => _descricao;
// ignore: unnecessary_getters_setters
  set descricao(String value) {
    _descricao = value;
  }
}