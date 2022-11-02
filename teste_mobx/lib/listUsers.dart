import 'dart:convert' as convert;
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
part 'listUsers.g.dart';

class ListUser = _ListUser with _$ListUser;

abstract class _ListUser with Store {
  @observable
  List<Map<String, dynamic>> listUser = [];
  @observable
  Map<String, dynamic> queryParameters = {
    'results': '20',
    'page': '1',
    'nat': 'br',
  };
  @observable
  int page = 0;

  @action
  Future getUsers() async {
    page++;
    queryParameters['page'] = page.toString();

    var url = Uri.https('randomuser.me', '/api/', queryParameters);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var users = jsonResponse['results'];
      for (var item in users) {
        listUser.add(item);
      }
      print('total pagina $page');
      return listUser;
    }
  }
}
