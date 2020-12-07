import 'package:flutter/material.dart';

class EntradaSlider extends StatefulWidget {
  @override
  _EntradaSliderState createState() => _EntradaSliderState();
}

class _EntradaSliderState extends State<EntradaSlider> {

  var _mensagem = "Resultado";
  String label;

  double _valor = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Entrada Slider"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget> [

            Slider(
              activeColor: Colors.red,
                inactiveColor: Colors.black,
                value: _valor,
                min: 0,
                max: 10 ,
                label: label,
                divisions: 10,
                onChanged: (double valor){
                setState(() {
                  _valor = valor;
                  _mensagem = _valor.toString();
                  label = "Valor selecionado: " + _valor.toString();

                });
                }
            ),

            RaisedButton(
                child: Text("Executar"),
                onPressed: (){
                  setState(() {
                   _mensagem = _valor.toString();
                  });
                }
            ),
            Padding(padding: EdgeInsets.all(16),
            child: Text(_mensagem),)
          ],
        ),
      ),
    );
  }
}
