class Produtos {
  String _nome;
  String _descricao;
  String _preco;
  String _urlImagem;
  String _idEmpresa;
  bool _estoqueAtivo;
  int _estoque;
  String _id;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get descricao => this._descricao;

  set descricao(value) => this._descricao = value;

  get preco => this._preco;

  set preco(value) => this._preco = value;

  get urlImagem => this._urlImagem;

  set urlImagem(value) => this._urlImagem = value;

  get idEmpresa => this._idEmpresa;

  set idEmpresa(value) => this._idEmpresa = value;

  get estoqueAtivo => this._estoqueAtivo;

  set estoqueAtivo(value) => this._estoqueAtivo = value;

  get estoque => this._estoque;

  set estoque(value) => this._estoque = value;

  get id => this._id;

  set id(value) => this._id = value;
}
