
import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
    TextEditingController _editingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de Dados"),
      ),
      body: Column(
        children:<Widget> [
          Padding(padding: EdgeInsets.all(32),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Digite um valor"
            ),
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
           // obscureText: false,
           //onChanged: (String texto){},
            //onSubmitted: (String texto){},
            controller: _editingController,
          ),
          ),
          RaisedButton(
          child: Text("Salvar"),
          color: Colors.lightGreen,
          onPressed: (){
            print("valor digitado " + _editingController.text);
          }),
        ],
      )
      );
  }
}
