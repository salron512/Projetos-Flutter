import 'package:uber/Model/Destino.dart';
import 'package:uber/Model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requisicao{

  String _id;
  String _status;
  Usuario _passageiro;
  Usuario _motorista;
  Destino _destino;


  Requisicao(){
    Firestore db = Firestore.instance;
    DocumentReference ref = db.collection("requisicoes").document();
    this.id = ref.documentID;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosPasageiro = {
      "nome": this.passageiro.nome,
      "email": this.passageiro.email,
      "tipoUsuario": this.passageiro.tipoUsuario,
      "idUsuario": this.passageiro.idUsuario,
      "latitude": this.passageiro.latitude,
      "longitude": this.passageiro.longitude,
    };
    Map<String, dynamic> dadosDestino = {
     "rua": this.destino.rua,
     "numero": this.destino.numero,
     "bairro": this.destino.bairro,
     "cep": this.destino.cep,
      "latitude": this.destino.latitude,
      "longetude": this.destino.longitude
    };
    Map<String, dynamic> dadosRequisicao = {
      "id": this.id,
      "status": this.status,
      "passageiro": dadosPasageiro,
      "motorista": null,
      "destino": dadosDestino
    };
    return dadosRequisicao;
  }

  Destino get destino => _destino;

  set destino(Destino value) {
    _destino = value;
  }

  Usuario get motorista => _motorista;

  set motorista(Usuario value) {
    _motorista = value;
  }

  Usuario get passageiro => _passageiro;

  set passageiro(Usuario value) {
    _passageiro = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}