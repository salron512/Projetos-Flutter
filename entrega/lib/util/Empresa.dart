class Empresa {
  String _nomeFantasia;
  String _descricao;
  String _categoria;
  String _urlImagem;
  String _idImagem;
  String _hAbertura;
  String _hFechamento;
  String _diasFunc;
  String _idEmpresa;
  
 String get idEmpresa => this._idEmpresa;

 set idEmpresa(String value) => this._idEmpresa = value;

  String get diasFunc => _diasFunc;

  set diasFunc(String value) {
    _diasFunc = value;
  }

  String get hAbertura => this._hAbertura;

  set hAbertura(String value) => this._hAbertura = value;

  get hFechamento => this._hFechamento;

  set hFechamento(value) => this._hFechamento = value;
  get nomeFantasia => this._nomeFantasia;

  set nomeFantasia(value) => this._nomeFantasia = value;

  get descricao => this._descricao;

  set descricao(value) => this._descricao = value;

  get categoria => this._categoria;

  set categoria(value) => this._categoria = value;

  get urlImagem => this._urlImagem;

  set urlImagem(value) => this._urlImagem = value;

  get idImagem => this._idImagem;

  set idImagem(value) => this._idImagem = value;
}
