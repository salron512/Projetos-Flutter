import 'package:cloud_firestore/cloud_firestore.dart';

class CheckListImplantacao {
  cadastraCheckList(String empresa, uid) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    
    db.collection("CheckList").doc().set({
      "uid": uid,
      "empresa": empresa,
      'item': "Descrição do item do check list",
      'modulo': 'Banco',
      'checado': false
    });

    db.collection("CheckList").doc().set({
      "uid": uid,
      "empresa": empresa,
      'item': "Descrição do item do check list",
      'modulo': 'Vendas',
      'checado': false
    });
    
    db.collection("CheckList").doc().set({
      "uid": uid,
      "empresa": empresa,
      'item': "Descrição do item do check list",
      'modulo': 'Vendas',
      'checado': false
    });
  }

  apagaCheckList(String empresa) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("CheckList")
        .where("empresa", isEqualTo: empresa)
        .get();
    for (var item in snapshot.docs) {
      FirebaseFirestore.instance.collection("CheckList").doc(item.id).delete();
    }
  }
}
