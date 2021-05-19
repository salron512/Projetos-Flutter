class Produtos {
  String _nome;
  String _descricao;
  String _preco;
  String _urlImagem;
  
 String get urlImagem => this._urlImagem;

 set urlImagem(String value) => this._urlImagem = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get descricao => this._descricao;

  set descricao(value) => this._descricao = value;

  get preco => this._preco;

  set preco(value) => this._preco = value;
}
