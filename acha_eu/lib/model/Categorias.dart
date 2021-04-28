class Categorias {
  String _nome;
  String _idImagem;
  String _urlImagem;
  String _cidade;
 

  Categorias();
   get cidade => this._cidade;

 set cidade( value) => this._cidade = value;

  // ignore: unnecessary_getters_setters
  String get urlImagem => _urlImagem;
// ignore: unnecessary_getters_setters
  set urlImagem(String value) {
    _urlImagem = value;
  }

// ignore: unnecessary_getters_setters
  String get idImagem => _idImagem;
// ignore: unnecessary_getters_setters
  set idImagem(String value) {
    _idImagem = value;
  }

// ignore: unnecessary_getters_setters
  String get nome => _nome;
// ignore: unnecessary_getters_setters
  set nome(String value) {
    _nome = value;
  }
}
