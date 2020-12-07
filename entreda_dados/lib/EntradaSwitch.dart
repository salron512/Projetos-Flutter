import 'package:flutter/material.dart';

class EntradaSwitch extends StatefulWidget {
  @override
  _EntradaSwitchState createState() => _EntradaSwitchState();
}

class _EntradaSwitchState extends State<EntradaSwitch> {
  bool _escolhaUsuario = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Entrada Switch"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children:<Widget> [

            SwitchListTile(
                title: Text(" Dejesa receber notificações?"),
                activeColor: Colors.red,
                value: _escolhaUsuario,
                onChanged: (bool valor){
                  setState(() {
                    _escolhaUsuario = valor;
                  });
                }
            ),
            RaisedButton(
                child: Text("Executar"),
                onPressed: (){
                  print("Resultado:" + _escolhaUsuario.toString());
                }
            )



            /*
            Switch(value: _escolhaUsuario,
                onChanged: (bool valor){
              setState(() {
                _escolhaUsuario = valor;
              });
              
                }
            ),
            Text("Receber notificações?")

            */
          ],
        ),
      ),
    );
  }
}
