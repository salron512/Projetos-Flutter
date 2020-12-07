import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _textoSalvo = "Nada Salvo!";

  TextEditingController _controllerCampo = TextEditingController();

  _salvar() async{
    String valorDigitado = _controllerCampo.text;

    final prefs = await SharedPreferences.getInstance();
     await prefs.setString("nome", valorDigitado);
     setState(() {
       _textoSalvo = "Dados salvos";
     });

  }
  _recuperar() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString("nome") ?? "Sem valor";

    });

}
  _remover()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nome");
    setState(() {
      _textoSalvo = "Dados removidos";
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manipulação de dados"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children:<Widget> [
            Text(_textoSalvo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Padding(
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Digite alvo",
                ),
                  controller: _controllerCampo,
              ),
              padding: EdgeInsets.all(15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
              children: [
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: _salvar,
                  child: Text("Salvar"),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: _recuperar,
                  child: Text("Recuperar"),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: _remover,
                  child: Text("Remover"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
