class Dados {
  String _album;
  String _nome;
  String _object;
  String _objectUpload;
  String _duracao;
  String _parametroPesquisa;
  String _ano;
  String _totalFaixas;
  Dados();


  String get parametroPesquisa => _parametroPesquisa;

  set parametroPesquisa(String value) {
    _parametroPesquisa = value;
  }

  String get duracao => _duracao;

  set duracao(String value) {
    _duracao = value;
  }

  String get objectUpload => _objectUpload;

  set objectUpload(String value) {
    _objectUpload = value;
  }

  String get object => _object;

  set object(String value) {
    _object = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get album => _album;

  set album(String value) {
    _album = value;
  }

  String get ano => _ano;

  String get totalFaixas => _totalFaixas;

  set totalFaixas(String value) {
    _totalFaixas = value;
  }

  set ano(String value) {
    _ano = value;
  }
}
