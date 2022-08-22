// ignore_for_file: unnecessary_this

class Modulo {
  late String _nome;
  late String _url;
  late String _urlImagem;
  late String _empresa;


  get empresa => this._empresa;

 set empresa( value) => this._empresa = value;

  String get urlImagem => this._urlImagem;

  set urlImagem(String value) => this._urlImagem = value;

  String get url => this._url;

  set url(String value) => this._url = value;
  String get nome => this._nome;

  set nome(String value) => this._nome = value;
}
