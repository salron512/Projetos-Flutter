class Usuario {

  String _nome;
  String _telefone;
  String _whatsapp;
  String _endereco;
  String _bairro;
  String _pontoReferencia;
  String _cidade;
  bool _adm;
  String _email;
  String _senha;

  Usuario();

  String get pontoReferencia => _pontoReferencia;

  set pontoReferencia(String value) {
    _pontoReferencia = value;
  }

  bool get adm => _adm;

  set adm(bool value) {
    _adm = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
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

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }
}