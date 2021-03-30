class Produtos{
  String _nome;
  String _marca;
  String _qtd;

  Produtos();

  String get qtd => _qtd;

  set qtd(String value) {
    _qtd = value;
  }

  String get marca => _marca;

  set marca(String value) {
    _marca = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}