// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';


class CheckListImplantacao {
  FirebaseFirestore db = FirebaseFirestore.instance;
  cadastraCheckList(String empresa, uid) {
    String dataCadastro = DateTime.now().microsecondsSinceEpoch.toString();
    db.collection("CheckList").doc().set({
      "dataCadastro": dataCadastro,
      "uid": uid,
      "empresa": empresa,
      'item': "Descrição do item do check list",
      'modulo': 'Banco',
      'checado': false
    });

    db.collection("CheckList").doc().set({
      "dataCadastro": dataCadastro,
      "uid": uid,
      "empresa": empresa,
      'item': "Descrição do item do check list",
      'modulo': 'Vendas',
      'checado': false
    });

    db.collection("CheckList").doc().set({
      "dataCadastro": dataCadastro,
      "uid": uid,
      "empresa": empresa,
      'item': "Descrição do item do check list",
      'modulo': 'Vendas',
      'checado': false
    });
  }

  apagaCheckList(String empresa) async {
    QuerySnapshot snapshot = await db
        .collection("CheckList")
        .where("empresa", isEqualTo: empresa)
        .get();
    for (var item in snapshot.docs) {
      FirebaseFirestore.instance.collection("CheckList").doc(item.id).delete();
    }
  }

  alteraEmpresa(String empresa, empresaEditada) async {
    QuerySnapshot snapshot = await db
        .collection("CheckList")
        .where("empresa", isEqualTo: empresa)
        .get();
    for (var item in snapshot.docs) {
      FirebaseFirestore.instance
          .collection('CheckList')
          .doc(item.id)
          .update({"empresa": empresaEditada});
    }
  }
}
