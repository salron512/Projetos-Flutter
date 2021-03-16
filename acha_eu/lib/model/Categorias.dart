class Categorias {
 String _nome;
 String _idImagem;
 String _urlImagem;

 Categorias();

 String get urlImagem => _urlImagem;

 set urlImagem(String value) {
   _urlImagem = value;
 }

 String get idImagem => _idImagem;

  set idImagem(String value) {
    _idImagem = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}