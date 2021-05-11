import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  _pagamento() async {
    String email = "andre.vicensotti@gmail.com";
    Uri urlBase = Uri.parse("https://ws.sandbox.pagseguro.uol.com.br/" +
        "{{api-endpoint}}?email={{$email}}" +
        "&token={{token-sandbox}}");
    Map<String, dynamic> dadosPagamento = {

    };

    String corpo = jsonEncode(dadosPagamento);
    http.Response response = await http.post(urlBase,
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: corpo);

    print("resposta status code: " + response.statusCode.toString());
    print("resposta: " + response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamento"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _pagamento();
                    },
                    child: Text("Pagar"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
