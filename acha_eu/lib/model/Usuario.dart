class Usuario {
  String _idUsuario;
  String _nome;
  String _email;
  String _senha;
  String _urlImagem;
  String _ref;
  String _telefone;
  String _whatsapp;
  String _cidade;
  String _estado;
  String _categoriaUsuario;
  String _descricao;
  String _descricaoAtividade;
  bool _mostraPagamento;
  bool _adm;
  bool _dinheiro;
  bool _cartaoCredito;
  bool _cartaoDebito;
  bool _cheque;
  bool _pix;


  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "telefone": this.telefone,
      "estado": this.estado,
      "whatsapp": this.whatsapp,
      "cidade": this.cidade,
      "categoria": this.categoriaUsuario,
      "mostraPagamento": this.mostraPagamento,
      "adm": this.adm,
    };

    return map;
  }

// ignore: unnecessary_getters_setters
  bool get adm => _adm;
// ignore: unnecessary_getters_setters
  set adm(bool value) {
    _adm = value;
  }
// ignore: unnecessary_getters_setters
  bool get mostraPagamento => _mostraPagamento;
// ignore: unnecessary_getters_setters
  set mostraPagamento(bool value) {
    _mostraPagamento = value;
  }


// ignore: unnecessary_getters_setters
  String get descricao => _descricao;
// ignore: unnecessary_getters_setters
  set descricao(String value) {
    _descricao = value;
  }
// ignore: unnecessary_getters_setters
  String get descricaoAtividade => _descricaoAtividade;
// ignore: unnecessary_getters_setters
  set descricaoAtividade(String value) {
    _descricaoAtividade = value;
  }
// ignore: unnecessary_getters_setters
  bool get dinheiro => _dinheiro;
// ignore: unnecessary_getters_setters
  set dinheiro(bool value) {
    _dinheiro = value;
  }
// ignore: unnecessary_getters_setters
  String get whatsapp => _whatsapp;
// ignore: unnecessary_getters_setters
  set whatsapp(String value) {
    _whatsapp = value;
  }
// ignore: unnecessary_getters_setters
  String get categoriaUsuario => _categoriaUsuario;
// ignore: unnecessary_getters_setters
  set categoriaUsuario(String value) {
    _categoriaUsuario = value;
  }

  String get ref => this._ref;

 set ref(String value) => this._ref = value;
  
  String get telefone => this._telefone;

  set telefone(String value) => this._telefone = value;

  get cidade => this._cidade;

  set cidade(value) => this._cidade = value;

  get estado => this._estado;

  set estado(value) => this._estado = value;

  

  // ignore: unnecessary_getters_setters
  String get idUsuario => _idUsuario;
// ignore: unnecessary_getters_setters
  set idUsuario(String value) {
    _idUsuario = value;
  }
// ignore: unnecessary_getters_setters
  String get urlImagem => _urlImagem;
// ignore: unnecessary_getters_setters
  set urlImagem(String value) {
    _urlImagem = value;
  }
// ignore: unnecessary_getters_setters
  String get senha => _senha;
// ignore: unnecessary_getters_setters
  set senha(String value) {
    _senha = value;
  }
// ignore: unnecessary_getters_setters
  String get email => _email;
// ignore: unnecessary_getters_setters
  set email(String value) {
    _email = value;
  }
// ignore: unnecessary_getters_setters
  String get nome => _nome;
// ignore: unnecessary_getters_setters
  set nome(String value) {
    _nome = value;
  }
// ignore: unnecessary_getters_setters
  bool get cartaoCredito => _cartaoCredito;
// ignore: unnecessary_getters_setters
  bool get pix => _pix;
// ignore: unnecessary_getters_setters
  set pix(bool value) {
    _pix = value;
  }
// ignore: unnecessary_getters_setters
  bool get cheque => _cheque;
// ignore: unnecessary_getters_setters
  set cheque(bool value) {
    _cheque = value;
  }
// ignore: unnecessary_getters_setters
  bool get cartaoDebito => _cartaoDebito;
// ignore: unnecessary_getters_setters
  set cartaoDebito(bool value) {
    _cartaoDebito = value;
  }
// ignore: unnecessary_getters_setters
  set cartaoCredito(bool value) {
    _cartaoCredito = value;
  }
}
