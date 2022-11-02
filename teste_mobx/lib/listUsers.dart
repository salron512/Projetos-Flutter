import 'dart:convert' as convert;
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
part 'listUsers.g.dart';

class ListUser = _ListUser with _$ListUser;

abstract class _ListUser with Store {
  @observable
  List<Map<String, dynamic>> listUser = [];

  @action
  Future getUsers() async {
    final queryParameters = {
      'results': '20',
      'nat': 'br',
    };
    var url = Uri.https('randomuser.me', '/api/', queryParameters);
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var users = jsonResponse['results'];
      for (var item in users) {
        listUser.add(item);
      }
      print('total consulta ${listUser.length}');
      return listUser;
    }
  }
}
