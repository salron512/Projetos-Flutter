import 'dart:async';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';

class PostgresDatabase implements RemoteDatabase, Disposable {
  PostgresDatabase() {
    _init();
  }
  final completer = Completer<PostgreSQLConnection>();
  _init() async {
    var connection = PostgreSQLConnection("localhost", 5432, "dart_test",
        username: "dart", password: "dart");
    await connection.open();
    completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, String> variables = const {},
  }) async {
    final connection = await completer.future;
    return await connection.mappedResultsQuery(queryText,
        substitutionValues: variables);
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }
}
