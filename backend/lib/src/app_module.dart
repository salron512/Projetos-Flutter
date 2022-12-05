import 'package:backend/src/core/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/bcrypt/bcrypt_service_imp.dart';
import 'package:backend/src/core/services/database/postgres/postgres_database.dart';
import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/core/services/dot_env/dot_env_services.dart';
import 'package:backend/src/features/swagger/swagger_handler.dart';
import 'package:backend/src/features/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService()),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i())),
        Bind.singleton<BCryptService>((i) => BCryptServiceImpl()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Inicial')),
        Route.get('/documentation/**', swaggerHandler),
        Route.resource(UserResource()),
      ];
}
