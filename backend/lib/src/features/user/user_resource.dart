import 'dart:async';

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

  FutureOr<Response> _getAllUser() {
    return Response.ok('bucando usuario');
  }

  FutureOr<Response> _getUserById(ModularArguments arguments) {
    return Response.ok(arguments.params['id']);
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
