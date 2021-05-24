
import 'package:firebase_auth/firebase_auth.dart';


class RecuperaDadosFirebase {
  // ignore: non_constant_identifier_names
  static RECUPERAUSUARIO() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid;
    return uid;
  }

}
