
import 'package:firebase_auth/firebase_auth.dart';

class RecuperaFirebase {
  static recuperaUsuario() {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: non_constant_identifier_names
    final USERID = auth.currentUser.uid;
    return USERID;
  }
}
