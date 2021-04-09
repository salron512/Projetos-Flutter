import 'package:acha_eu/util/RecuperaFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  var _mascaraCartao = new MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  var _mascaraCodigo = new MaskTextInputFormatter(
      mask: '###', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController _controllerCartao = TextEditingController();
  TextEditingController _controllerCodigoSeguracao = TextEditingController();
  String _mensagemErro = "Realize o pagamento"
      " para se tornar um anúnciante em sua ciddade ";


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
  _salvapagamento(){
   String id = RecuperaFirebase.recuperaUsuario();
   FirebaseFirestore db = FirebaseFirestore.instance;
   db.collection("usuarios").doc(id).update({
     "diaPagamento": DateTime.now().day,
     "mesPagamento": DateTime.now().month,
     "anoPagamento": DateTime.now().year,
     "mostraPagamento": true,
   });
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
                padding:
                EdgeInsets.only(bottom: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [_mascaraCartao],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      labelText: "Cartão de crédito",
                      contentPadding:
                      EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                padding:
                EdgeInsets.only(bottom: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [_mascaraCodigo],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      labelText: "Código de segurança",
                      contentPadding:
                      EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                child: RaisedButton(
                  child: Text(
                    "Realizar pagamento",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff37474f),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {
                    _salvapagamento();
                  },
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}
