import 'package:backend/src/app_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

Future<Handler> startShelfModular() async {
  var handler = Modular(module: AppModule(), middlewares: [
    logRequests(),
  ]);
  return handler;
}
