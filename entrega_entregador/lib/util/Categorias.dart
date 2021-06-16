class Categorias {
  String _categoria;
  String _urlImagem;
  String _idImagem;
  String _horaAbertura;
  String _horaFechamento;

  String get horaAbertura => this._horaAbertura;

  set horaAbertura(String value) => this._horaAbertura = value;

  get horaFechamento => this._horaFechamento;

  set horaFechamento(value) => this._horaFechamento = value;

  get categoria => this._categoria;

  set categoria(value) => this._categoria = value;

  get urlImagem => this._urlImagem;

  set urlImagem(value) => this._urlImagem = value;

  get idImagem => this._idImagem;

  set idImagem(value) => this._idImagem = value;
}
