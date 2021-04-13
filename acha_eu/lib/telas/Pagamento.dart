import 'package:acha_eu/model/Usuario.dart';
import 'package:acha_eu/util/RecuperaFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  var _mascaraCartao = new MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraCodigo =
      new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraVencimento = new MaskTextInputFormatter(
      mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController _controllerCartao = TextEditingController();
  TextEditingController _controllerCodigoSeguracao = TextEditingController();
  TextEditingController _controllerNomeCartao = TextEditingController();
  TextEditingController _controllerCartaoVencimento = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  String _mensagemErro = "Realize o pagamento"
      " para se tornar um anúnciante em sua cidade ";

  /*
    DateTime pagamentoDia = DateTime(anoPagamento, mesPagamento, diaPagamento);
    var diaAtual = DateTime.now();
    var resultado = diaAtual
        .difference(pagamentoDia)
        .inDays;
    print("resultado em dias: " + resultado.toString());
    if(resultado > 32){
      print("vencido");
    }else{
      print("pagamento ok!");
    }
  }
  @override
  void initState() {
    super.initState();
  }
   */
  _salvapagamento() async {
    String id = RecuperaFirebase.recuperaUsuario();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios").doc(id).update({
      "diaPagamento": DateTime.now().day,
      "mesPagamento": DateTime.now().month,
      "anoPagamento": DateTime.now().year,
      "mostraPagamento": true,
    });
    var url = Uri.parse("https://api.pagar.me/1/transactions/");

    String numeroCartao = _controllerCartao.text;
    String numeroCodigoSeguracao = _controllerCodigoSeguracao.text;
    String vencimento = _controllerCartaoVencimento.text;
    String nomeCartao = _controllerNomeCartao.text;
    String cpf = _controllerCPF.text;

    DocumentSnapshot snapshot = await db.collection("usuarios").doc(id).get();
    Map<String, dynamic> dadosUsuario = snapshot.data();
    Usuario usuario = Usuario();
    usuario.nome = dadosUsuario["nome"];
    usuario.email = dadosUsuario["email"];
    usuario.telefone =  _mascaraCartao.unmaskText(dadosUsuario["telefone"]);
    usuario.whatsapp =  _mascaraCartao.unmaskText(dadosUsuario["whatsapp"]);
    //String test = _mascaraCartao.unmaskText(usuario.whatsapp);
    //print("teste marcara: " +test);

    var corpo = json.encode({
      "api_key": "ak_live_Km1jt6ZkY3RnXEf4imoenyC5hYK3mD",
      "amount": 21000,
      "card_number": _mascaraCartao.unmaskText(numeroCartao),
      "card_cvv":  _mascaraCartao.unmaskText(numeroCodigoSeguracao),
      "card_expiration_date":  _mascaraCartao.unmaskText(vencimento),
      "card_holder_name": nomeCartao,
      "customer": {
        "external_id": id,
        "name": usuario.nome,
        "type": "individual",
        "country": "br",
        "email": usuario.email,
        "documents": [
          {"type": "cpf", "number": cpf}
        ],
        "phone_numbers": ["+55" + usuario.telefone, "+55" + usuario.whatsapp],
        "birthday": "1965-01-01"
      },
      "billing": {
        "name": "André Ricardo Vicensotti",
        "address": {
          "country": "br",
          "state": "mt",
          "city": "Curvelândia",
          "neighborhood": "Zona Rural",
          "street": "MT 170 km 33",
          "street_number": "0000",
          "zipcode": "78237000"
        }
      },
      "items": [
        {
          "id": "r123",
          "title": "Serviço de marketing",
          "unit_price": 10000,
          "quantity": 1,
          "tangible": false
        }
      ]
    });

    http.Response response = await http.post(url,
        headers: {"content-type": 'application/json'}, body: corpo);

    print("status code: " + response.statusCode.toString());
    print("status code: " + response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamento"),
      ),
      body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      "images/cartao.png",
                      width: 250,
                      height: 200,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Center(
                          child: Text(
                        _mensagemErro,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ))),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          labelText: "Nome do titular ",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerNomeCartao,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [_mascaraCartao],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          labelText: "Cartão de crédito",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                            ),
                            onPressed: () {
                              setState(() {
                                _controllerCartao.clear();
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerCartao,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [_mascaraVencimento],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          labelText: "Vencimento do cartão",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                            ),
                            onPressed: () {
                              setState(() {
                                _controllerCartaoVencimento.clear();
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerCartaoVencimento,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [_mascaraCodigo],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          labelText: "Código de segurança",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                            ),
                            onPressed: () {
                              setState(() {
                                _controllerCodigoSeguracao.clear();
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerCodigoSeguracao,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          labelText: "Digite o seu CPF apenas números",
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      controller: _controllerCPF,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                      child: Text(
                        "Realizar pagamento",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff37474f),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      onPressed: () {
                        _salvapagamento();
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
