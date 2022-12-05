import 'package:backend/src/core/services/dot_env/dot_env_services.dart';
import 'package:backend/src/core/services/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:test/test.dart';

void main() {
  test('jwt create', () async {
    final dotEnvService = DotEnvService(mocks: {'JWT_KEY': 'dfgdfgdfgdfg'});
    final expiresData = DateTime.now().add(Duration(seconds: 30));
    final expeiresIn =
        Duration(microseconds: expiresData.microsecondsSinceEpoch).inSeconds;
    final jwt = JwtServiceImpl(dotEnvService);
    final token = jwt.generateToken({
      'id': 1,
      'role': 'user',
      'exp': expeiresIn,
    }, 'acessToken');
    print(token);
  });
}
