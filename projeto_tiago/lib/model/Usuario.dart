class Usuario {
  String _nome;
  String _telefone;
  String _whatsapp;
  String _endereco;
  String _bairro;
  String _pontoReferencia;
  String _cidade;
  bool _adm;
  bool _entregador;
  String _email;
  String _senha;
  String _id;


  Usuario();

get id => this._id;
 set id( value) => this._id = value;

  bool get entregador => this._entregador;
  set entregador(bool value) => this._entregador = value;

  // ignore: unnecessary_getters_setters
  String get pontoReferencia => _pontoReferencia;

  // ignore: unnecessary_getters_setters
  set pontoReferencia(String value) {
    _pontoReferencia = value;
  }

// ignore: unnecessary_getters_setters
  bool get adm => _adm;
// ignore: unnecessary_getters_setters
  set adm(bool value) {
    _adm = value;
  }

// ignore: unnecessary_getters_setters
  String get cidade => _cidade;
// ignore: unnecessary_getters_setters
  set cidade(String value) {
    _cidade = value;
  }

// ignore: unnecessary_getters_setters
  String get email => _email;
// ignore: unnecessary_getters_setters
  set email(String value) {
    _email = value;
  }

// ignore: unnecessary_getters_setters
  String get bairro => _bairro;
// ignore: unnecessary_getters_setters
  set bairro(String value) {
    _bairro = value;
  }

// ignore: unnecessary_getters_setters
  String get endereco => _endereco;
// ignore: unnecessary_getters_setters
  set endereco(String value) {
    _endereco = value;
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
  String get senha => _senha;
// ignore: unnecessary_getters_setters
  set senha(String value) {
    _senha = value;
  }
}
