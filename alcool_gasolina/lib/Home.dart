import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  TextEditingController _ControllerAlcool = TextEditingController();
  TextEditingController _ControllerGasolina = TextEditingController();
  var _resultado = "Resultado";

  void _cacular() {
    double precoAlcool = double.tryParse(_ControllerAlcool.text);
    double precoGasolina = double.tryParse(_ControllerGasolina.text);

    if ((precoAlcool == null || precoGasolina == null) ||
        (precoAlcool == "" || precoGasolina == "")) {
      setState(() {
        _resultado = " Valor Invalido";
      });
    }else{
      if(( precoAlcool / precoGasolina) >= 0.7){
        setState(() {
          _resultado = "Melhor abastecer com gasolina";
        });
      }else{
        setState(() {
          _resultado = "Melhor abastecer com alcool";
        });
      }
    }
    limparCampos();
  }
  void limparCampos(){
    _ControllerGasolina.text ="";
    _ControllerAlcool.text = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alcool ou Gasolina"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget> [
              Padding(
                padding: (EdgeInsets.only(bottom: 32)),
                child: Image.asset("images/logo.png"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Saiba qual a melhor opção para abastecimento do seu carro",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                ) ,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Preço Alcool, ex: 2.59"
                ),
                style: TextStyle(
                    fontSize: 22
                ),
                controller: _ControllerAlcool,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Preço Gasolina, ex: 4.69"
                ),
                style: TextStyle(
                    fontSize: 22
                ),
                controller: _ControllerGasolina ,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),

                  child: Text(
                    "Calcular",
                    style: TextStyle(
                      fontSize: 20
                  ),
                  ),
                  onPressed: _cacular,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20),
                child: Text(_resultado,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ) ,
                    textAlign: TextAlign.center
                ),
              )
            ],
          ),
        ) ,
      ),
    );
  }
}
