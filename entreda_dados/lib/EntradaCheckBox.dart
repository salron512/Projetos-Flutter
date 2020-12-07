import 'package:entreda_dados/CampoTexto.dart';
import 'package:flutter/material.dart';


class EntradaCheckbox extends StatefulWidget {
  @override
  _EntradaCheckboxState createState() => _EntradaCheckboxState();
}

class _EntradaCheckboxState extends State<EntradaCheckbox> {

  bool _comidaBrasileira = false;
  bool _comidaMexicana = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Entrada de Dados"
            ),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children:<Widget> [
            CheckboxListTile(
              title: Text("Comida Brasileira"),
                subtitle: Text("A melhor comida do mundo"),
                activeColor: Colors.red,
                //secondary: Icon(Icons.add_circle_outline_sharp),
                value: _comidaBrasileira,
                onChanged: (bool valor){
                setState(() {
                  _comidaBrasileira = valor;
                });
                }
            ),
            CheckboxListTile(
                title: Text("Comida Mexicana"),
                subtitle: Text("A melhor comida do mundo"),
                activeColor: Colors.red,
                //secondary: Icon(Icons.add_circle_outline_sharp),
                value: _comidaMexicana,
                onChanged: (bool valor1){
                  setState(() {
                    _comidaMexicana = valor1;
                  });
                }
            ),
            RaisedButton(
                child: Text("Salvar", style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,),),
                onPressed: (){}
                ),

            /*Checkbox(
                value: _estaSelecionado,
                onChanged: (bool valor){
                  setState(() {
                    _estaSelecionado = valor;
                  });
                }
            )*/



            
          ],
        ),
      ),
    );
  }
}
