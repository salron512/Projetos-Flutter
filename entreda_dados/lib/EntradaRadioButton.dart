import 'package:flutter/material.dart';

class EntradaRadioButton extends StatefulWidget {
  @override
  _EntradaRadioButtonState createState() => _EntradaRadioButtonState();
}

class _EntradaRadioButtonState extends State<EntradaRadioButton> {
  var mensagem;

  String _escolhaUsuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Entrada Radio Button"),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children:<Widget> [

            RadioListTile(
                title: Text("Masculino"),
                value: "m",
                groupValue: _escolhaUsuario,
                onChanged: (String escolhaUsuario){
                  setState(() {
                    _escolhaUsuario = escolhaUsuario;
                  });
                }),
            RadioListTile(
                title: Text("Feminino"),
                value: "f",
                groupValue: _escolhaUsuario,
                onChanged: (String escolhaUsuario){
                  setState(() {
                    _escolhaUsuario = escolhaUsuario;
                  });
                }),
            RaisedButton(
                child: Text("Executar"),
                onPressed:(){
                  setState(() {
                   mensagem = _escolhaUsuario.toString();
                  });
                }
            ),

            /*
            Text("Masculino"),
            Radio(
                value: "m",
                groupValue: _escolhaUsuario,
                onChanged: (String escolhaUsuario){
                  setState(() {
                    _escolhaUsuario = escolhaUsuario;
                  });
                }
            ),
            Text("Feminino"),
            Radio(
                value: "f",
                groupValue: _escolhaUsuario,
                onChanged: (String escolhaUsuario){
                  setState(() {
                    _escolhaUsuario = escolhaUsuario;
                  });
                }
            ),*/



          ],
        ),
      ),
    );
  }
}
