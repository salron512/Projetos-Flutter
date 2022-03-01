import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerVendedor = TextEditingController();
  TextEditingController _controllerEmpresa = TextEditingController();
  TextEditingController _controllerCliente = TextEditingController();
  TextEditingController _controllerProduto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Tela de venda"),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Vendedor",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: _controllerVendedor,
              ),
              
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Empresa",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: _controllerEmpresa,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Cliente",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: _controllerCliente,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Produto",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: _controllerProduto,
              ),
            
            ),
            Padding(
              padding: EdgeInsets.all(16),
            child: Container(
              width: 5000,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.red
              ),
            ),
            )
          ],
        ),
      ),
    );
  }
}
