import 'package:cloud_firestore/cloud_firestore.dart';

class Participantes {
   cadastraParticipantes(String empresa, modulo, colaboradores) {
    FirebaseFirestore.instance.collection("Participantes").doc().set({
      "modulo": modulo,
      'empresa': empresa,
      'colaboradores': colaboradores,
      'observacao': ''
    });
  }

  static void cadastraObs(String obs) {
    FirebaseFirestore.instance
        .collection("Participantes")
        .doc()
        .set({'observacao': obs});
  }
}
