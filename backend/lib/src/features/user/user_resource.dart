import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUser),
        Route.get('/user/:id', _getUserById),
        Route.post('/user', _createUser),
        Route.post('/user:id', _updateUser),
        Route.delete('/user:id', _deleteUser),
      ];

  FutureOr<Response> _getAllUser(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result =
        await database.query('SELECT id, name, email, role FROM "User";');
    final listUser = result.map((e) => e['User']).toList();

    return Response.ok(jsonEncode(listUser));
  }

  FutureOr<Response> _getUserById(ModularArguments arguments, Injector injector)
   async {
    final id = await arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id, name, email, role FROM "User" WHERE id = @id;',
        variables: {'id': id});
    final userMap = result.map((element) => element['User']).first;

    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _createUser(ModularArguments arguments) {
    return Response.ok('criando usuario ${arguments.data}');
  }

  FutureOr<Response> _updateUser(ModularArguments arguments) {
    return Response.ok('criando usuario ${arguments.data}');
  }

  FutureOr<Response> _deleteUser(ModularArguments arguments) {
    return Response.ok('criando usuario ${arguments.params}');
  }
}
