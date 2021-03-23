class Solicitacao{
  String _descricao;
  String _idSolicitante;
  String _categoria;
  String _nome;
  String _telefone;
  String _whatsapp;
  String _cidade;

  Solicitacao();

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get whatsapp => _whatsapp;

  set whatsapp(String value) {
    _whatsapp = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get idSolicitante => _idSolicitante;

  set idSolicitante(String value) {
    _idSolicitante = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }
}