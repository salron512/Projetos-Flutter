class Produtos {
  String _nome;
  String _marca;
  String _qtd;
  int _preco;
  Produtos();

get preco => this._preco;
 set preco( value) => this._preco = value;
 
  // ignore: unnecessary_getters_setters
  String get qtd => _qtd;
// ignore: unnecessary_getters_setters
  set qtd(String value) {
    _qtd = value;
  }

// ignore: unnecessary_getters_setters
  String get marca => _marca;
// ignore: unnecessary_getters_setters
  set marca(String value) {
    _marca = value;
  }

// ignore: unnecessary_getters_setters
  String get nome => _nome;
// ignore: unnecessary_getters_setters
  set nome(String value) {
    _nome = value;
  }
}
