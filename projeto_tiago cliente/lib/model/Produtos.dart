class Produtos {
  String _id;
  String _nome;
  String _marca;
  String _qtd;
  int _preco;
  int _estoque;

  Produtos();
  get id => this._id;
  set id(value) => this._id = value;

  get estoque => this._estoque;
  set estoque(value) => this._estoque = value;

  get preco => this._preco;
  set preco(value) => this._preco = value;

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
