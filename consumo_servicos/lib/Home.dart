import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}
TextEditingController _ControllerCep = TextEditingController();
String _resultado = "";
class _HomeState extends State<Home> {

  _recuperarCep() async {
    String cep = _ControllerCep.text;
    String url = "https://viacep.com.br/ws/$cep/json/";
      http.Response response;

      response = await http.get(url);
      Map<String, dynamic> retorno = json.decode(response.body);

      String logradouro = retorno["logradouro"];
      String complemento = retorno["complemento"];
      String bairro = retorno["bairro"];
      String localidade = retorno["localidade"];
      var validar = response.statusCode;
      bool conticao = false;

      if( validar == 200) {
       setState(() {
         _resultado = localidade;
       });
      } else {
          setState(() {
            _resultado = "Cep invalido";
          });
      }


















      //json.decode(response.body);
      //print("resposta" + response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço Web"),
      ),
      body: (
      Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children:<Widget> [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Digite o cep apenas números"
              ),
              style: TextStyle(
                  fontSize: 15
              ),
              controller: _ControllerCep  ,
            ),
            RaisedButton(
              child: Text("clique aqui"),
              onPressed: _recuperarCep ,
            ),
            Text("Resultado: " +_resultado),
          ],

        ) ,
      )
      ),
    );
  }
}
