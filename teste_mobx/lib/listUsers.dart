import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
part 'listUsers.g.dart';

class ListUser = _ListUser with _$ListUser;

abstract class _ListUser with Store {
  ObservableList<Map<String, dynamic>> listUser =
      ObservableList<Map<String, dynamic>>();

  @observable
  int page = 0;

  bool female = true;

  bool male = true;

  bool empty = true;
  @observable
  Map<String, dynamic> queryParameters = {
    'results': '20',
    'page': '1',
    'nat': 'br',
    'inc': 'gender,name,email,picture',
    'gender': ''
  };

  @action
  Future getUsers(String params) async {
    page++;
    queryParameters['page'] = page.toString();
    switch (params) {
      case '':
        queryParameters['gender'] = '';
        if (empty) {
          listUser.clear();
          page = 1;
        }
        female = true;
        male = true;
        empty = false;
        break;
      case 'female':
        queryParameters['gender'] = 'female';
        if (female) {
          listUser.clear();
          page = 1;
        }
        female = false;
        male = true;
        empty = true;
        break;
      case 'male':
        queryParameters['gender'] = 'male';
        if (male) {
          listUser.clear();
          page = 1;
        }
        female = true;
        male = false;
        empty = true;
        break;
    }

    var url = Uri.https('randomuser.me', '/api/', queryParameters);
  

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var users = jsonResponse['results'];
      for (var item in users) {
        listUser.add(item);
      }
    }
  }
}
