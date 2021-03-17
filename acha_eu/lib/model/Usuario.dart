class Usuario {
  String _idUsuario;
  String _nome;
  String _email;
  String _senha;
  String _urlImagem;
  String _cpf;
  String _telefone;
  String _whatsapp;
  String _cidade;
  String _estado;
  String _categoriaUsuario;
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
      "cpf": this.cpf,
      "categoria": this.categoriaUsuario,
    };

    return map;
  }


  bool get dinheiro => _dinheiro;

  set dinheiro(bool value) {
    _dinheiro = value;
  }

  String get whatsapp => _whatsapp;

  set whatsapp(String value) {
    _whatsapp = value;
  }

  String get categoriaUsuario => _categoriaUsuario;

  set categoriaUsuario(String value) {
    _categoriaUsuario = value;
  }

  String get cpf => this._cpf;

 set cpf(String value) => this._cpf = value;
  
  String get telefone => this._telefone;

  set telefone(String value) => this._telefone = value;

  get cidade => this._cidade;

  set cidade(value) => this._cidade = value;

  get estado => this._estado;

  set estado(value) => this._estado = value;

  

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  bool get cartaoCredito => _cartaoCredito;

  bool get pix => _pix;

  set pix(bool value) {
    _pix = value;
  }

  bool get cheque => _cheque;

  set cheque(bool value) {
    _cheque = value;
  }

  bool get cartaoDebito => _cartaoDebito;

  set cartaoDebito(bool value) {
    _cartaoDebito = value;
  }

  set cartaoCredito(bool value) {
    _cartaoCredito = value;
  }
}
