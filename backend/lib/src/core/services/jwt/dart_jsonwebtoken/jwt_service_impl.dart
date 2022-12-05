import 'package:backend/src/core/services/dot_env/dot_env_services.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtServiceImpl implements JwtSerice {
  final DotEnvService dotEnvService;
  JwtServiceImpl(this.dotEnvService);

  @override
  String generateToken(Map claims, String audiance) {
    final jwt = JWT(claims, audience: Audience.one(audiance));

    final token = jwt.sign(SecretKey(dotEnvService['JWT_KEY']!));

    return token;
  }

  @override
  void verifyToken(String token, String audiance) {
    JWT.verify(
        token,
        SecretKey(
          dotEnvService['JWT_KEY']!,
        ),
        audience: Audience.one(dotEnvService['JWT_KEY']!));
  }

  @override
  Map getPayLoad(String token) {
    final jwt = JWT.verify(
        token,
        SecretKey(
          dotEnvService['JWT_KEY']!,
        ),
        checkExpiresIn: false,
        checkHeaderType: false,
        checkNotBefore: false);
    return jwt.payload;
  }
}
