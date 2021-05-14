import 'package:firebase_auth/firebase_auth.dart';

class RecuperaFirebase {
  // ignore: non_constant_identifier_names
  static RECUPERAIDUSUARIO() {
    String idUsuario = FirebaseAuth.instance.currentUser.uid;
    return idUsuario;
  }
}
