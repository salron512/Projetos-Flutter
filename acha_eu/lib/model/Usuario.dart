class Usuario {
  String _idUsuario;
  String _nome;
  String _email;
  String _senha;
  String _urlImagem;
  String _cpf;
  String _telefone;
  String _cidade;
  String _estado;
  String _tipoUsuario;


  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "telefone": this.telefone,
      "estado": this.estado,
      "cidadade": this.cidade,
      "tipoUsuario": this.tipoUsuario
    };

    return map;
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
}
