// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listUsers.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ListUser on _ListUser, Store {
  late final _$listUserAtom =
      Atom(name: '_ListUser.listUser', context: context);

  @override
  List<Map<String, dynamic>> get listUser {
    _$listUserAtom.reportRead();
    return super.listUser;
  }

  @override
  set listUser(List<Map<String, dynamic>> value) {
    _$listUserAtom.reportWrite(value, super.listUser, () {
      super.listUser = value;
    });
  }

  late final _$queryParametersAtom =
      Atom(name: '_ListUser.queryParameters', context: context);

  @override
  Map<String, dynamic> get queryParameters {
    _$queryParametersAtom.reportRead();
    return super.queryParameters;
  }

  @override
  set queryParameters(Map<String, dynamic> value) {
    _$queryParametersAtom.reportWrite(value, super.queryParameters, () {
      super.queryParameters = value;
    });
  }

  late final _$pageAtom = Atom(name: '_ListUser.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$getUsersAsyncAction =
      AsyncAction('_ListUser.getUsers', context: context);

  @override
  Future<dynamic> getUsers() {
    return _$getUsersAsyncAction.run(() => super.getUsers());
  }

  @override
  String toString() {
    return '''
listUser: ${listUser},
queryParameters: ${queryParameters},
page: ${page}
    ''';
  }
}
