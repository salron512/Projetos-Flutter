class Clientes {
  late String _razaoSocial;
  late String _nomeFantasia;
  late String _bairro;
  late String _endereco;
  late String _telefone;
  late String _Cnpj;
  late String _cidade;
  late bool _ativo;

  Clientes();

  bool get ativo => this._ativo;

  set ativo(bool value) => this._ativo = value;

  get razaoSocial => this._razaoSocial;

  set razaoSocial(value) => this._razaoSocial = value;

  get nomeFantasia => this._nomeFantasia;

  set nomeFantasia(value) => this._nomeFantasia = value;

  get bairro => this._bairro;

  set bairro(value) => this._bairro = value;

  get endereco => this._endereco;

  set endereco(value) => this._endereco = value;

  get telefone => this._telefone;

  set telefone(value) => this._telefone = value;

  get Cnpj => this._Cnpj;

  set Cnpj(value) => this._Cnpj = value;

  get cidade => this._cidade;

  set cidade(value) => this._cidade = value;
}
