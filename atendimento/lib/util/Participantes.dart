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

  deleteParticipantes(String empresa) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db
        .collection('Participantes')
        .where('empresa', isEqualTo: empresa)
        .get();
    for (var item in snapshot.docs) {
      db.collection('Participantes').doc(item.id).delete();
    }
  }

  alteraEmpresa(String empresa, empresaEditada) async {
    print('EXECUTADO $empresaEditada');
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db
        .collection("Participantes")
        .where("empresa", isEqualTo: empresa)
        .get();
    for (var item in snapshot.docs) {
      FirebaseFirestore.instance
          .collection('Participantes')
          .doc(item.id)
          .update({"empresa": empresaEditada});
    }
  }
}
