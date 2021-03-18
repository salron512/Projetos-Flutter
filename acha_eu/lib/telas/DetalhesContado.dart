import 'package:acha_eu/model/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesContado extends StatefulWidget {
  Usuario usuario;
  DetalhesContado(this.usuario);

  @override
  _DetalhesContadoState createState() => _DetalhesContadoState();
}

class _DetalhesContadoState extends State<DetalhesContado> {
  bool _dinheiro = false;
  bool _cartaoDebito = false;
  bool _cartaoCredito = false;
  bool _cheque = false;
  bool _pix = false;

  _abrirWhatsApp() async {
    String telefone = widget.usuario.whatsapp;
    var whatsappUrl = "whatsapp://send?phone=+55$telefone=Olá,tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _recuperaFormaPagamento() {
   if(widget.usuario.dinheiro != null){
     if( widget.usuario.cartaoDebito != null ){
       if( widget.usuario.cartaoCredito != null ){
         if( widget.usuario.cheque != null ){
           if( widget.usuario.pix != null ){
             setState(() {
               _dinheiro = widget.usuario.dinheiro;
               _cartaoDebito = widget.usuario.cartaoDebito;
               _cartaoCredito = widget.usuario.cartaoCredito;
               _cheque = widget.usuario.cheque;
               _pix = widget.usuario.pix;
             });
           }
         }
       }
     }
   }
  }

  _abrirTelefone() async {
    String telefone = widget.usuario.telefone;
    var telefoneUrl = "tel:$telefone";

    if (await canLaunch(telefoneUrl)) {
      await launch(telefoneUrl);
    } else {
      throw 'Could not launch $telefoneUrl';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaFormaPagamento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario.nome),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffDCDCDC)),
        alignment: Alignment.center,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                    backgroundImage: widget.usuario.urlImagem != null
                        ? NetworkImage(widget.usuario.urlImagem)
                        : null,
                    maxRadius: 100,
                    backgroundColor: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(bottom: 16, top: 16),
                  child: RaisedButton(
                    child: Text(
                      "Whatasapp",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _abrirWhatsApp();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: RaisedButton(
                    child: Text(
                      "Telefone",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color:Color(0xff37474f),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _abrirTelefone();
                    },
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Color(0xffDCDCDC),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Formas de pagamento:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Visibility(
                            visible: _dinheiro,
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 5),
                                    child: Icon(
                                      Icons.payments_outlined,
                                      color: Colors.green,
                                    )),
                                Text(
                                  "Dinheiro",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )),
                        Visibility(
                            visible: _cartaoCredito,
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 5),
                                    child: Icon(
                                      Icons.credit_card,
                                      color: Colors.blue,
                                    )),
                                Text(
                                  "Cartão de credito",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )),
                        Visibility(
                            visible: _cartaoDebito,
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 5),
                                    child: Icon(
                                      Icons.credit_card,
                                      color: Colors.red,
                                    )),
                                Text(
                                  "Cartão de debito",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )),
                        Visibility(
                            visible: _cheque,
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 5),
                                    child: Icon(
                                      Icons.account_balance_outlined,
                                      color: Colors.orange,
                                    )),
                                Text(
                                  "Cheque",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )),
                        Visibility(
                            visible: _pix,
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 5),
                                    child: Icon(
                                      Icons.payment_outlined,
                                      color: Colors.purple,
                                    )),
                                Text(
                                  "Pix",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
