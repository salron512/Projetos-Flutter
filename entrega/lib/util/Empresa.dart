class Empresa {
  String _nome;
  String _descricao;
  String _categoria;
  String _urlImagem;
  String _idImagem;

  
 String get idImagem => this._idImagem;

 set idImagem(String value) => this._idImagem = value;

  String get urlImagem => this._urlImagem;

  set urlImagem(String value) => this._urlImagem = value;

  get categoria => this._categoria;

  set categoria(value) => this._categoria = value;

  String get nome => this._nome;

  set nome(String value) => this._nome = value;

  String get descricao => this._descricao;

  set descricao(String value) => this._descricao = value;
}
