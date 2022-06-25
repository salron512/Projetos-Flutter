class Produto {
  late var _codBarras;
  late var _descricao;
  late var _marca;
  late var _qtdCotacao;
  late var _embalagem;
  late var _custoReposicao;


  
  get codBarras => this._codBarras;

  set codBarras(value) => this._codBarras = value;

  get descricao => this._descricao;

  set descricao(value) => this._descricao = value;

  get marca => this._marca;

  set marca(value) => this._marca = value;

  get qtdCotacao => this._qtdCotacao;

  set qtdCotacao(value) => this._qtdCotacao = value;

  get embalagem => this._embalagem;

  set embalagem(value) => this._embalagem = value;

  get custoReposicao => this._custoReposicao;

  set custoReposicao(value) => this._custoReposicao = value;
  Produto();
}
