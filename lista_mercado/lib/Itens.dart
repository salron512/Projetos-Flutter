
class Itens{
 String _item;
 bool _estado;
 String _data;

 Itens();

 String get data => _data;

  set data(String value) {
    _data = value;
  }

  bool get estado => _estado;

  set estado(bool value) {
    _estado = value;
  }

  String get item => _item;

  set item(String value) {
    _item = value;
  }
}