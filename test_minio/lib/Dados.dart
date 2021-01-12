class Dados {
  String _album;
  String _nome;
  String _object;
  String _objectUpload;

  Dados();


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
}
