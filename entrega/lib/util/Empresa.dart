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
  bool _estado;
  bool _ativo;
  String _telefone;
  
 String get telefone => this._telefone;

 set telefone(String value) => this._telefone = value;

  bool get ativo => this._ativo;

  set ativo(bool value) => this._ativo = value;

  bool get estado => this._estado;

  set estado(bool value) => this._estado = value;

  String get idEmpresa => this._idEmpresa;

  set idEmpresa(String value) => this._idEmpresa = value;

  // ignore: unnecessary_getters_setters
  String get diasFunc => _diasFunc;

  // ignore: unnecessary_getters_setters
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
