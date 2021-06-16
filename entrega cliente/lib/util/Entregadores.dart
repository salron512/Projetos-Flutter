class Entegadores {
  String _nome;
  String _telefone;
  String _whatsapp;
  String _endereco;
  String _bairro;
  String _email;
  bool _ativo;
  String _uid;
  
 String get uid => this._uid;

 set uid(String value) => this._uid = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  String get telefone => this._telefone;

  set telefone(String value) => this._telefone = value;

  String get whatsapp => this._whatsapp;

  set whatsapp(String value) => this._whatsapp = value;

  String get endereco => this._endereco;

  set endereco(String value) => this._endereco = value;

  String get bairro => this._bairro;

  set bairro(String value) => this._bairro = value;

  String get email => this._email;

  set email(String value) => this._email = value;

  bool get ativo => this._ativo;

  set ativo(bool value) => this._ativo = value;
}
