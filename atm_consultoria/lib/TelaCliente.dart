import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaCliente extends StatefulWidget {
  @override
  _TelaClienteState createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Clientes"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:<Widget> [
                Image.asset("images/detalhe_cliente.png"),
                Padding(padding: EdgeInsets.only(left: 15),
                child: Text("Clientes", style: TextStyle(
                fontSize: 30
                ),
                ) ,
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top:10,bottom: 10 ),
              child: Image.asset("images/cliente1.png"),
            ),
            Text("Empresa de Software"),
            Padding(
              padding: EdgeInsets.only(top:10,bottom: 10 ),
              child: Image.asset("images/cliente2.png"),
            ),
            Text("Empresa de Auditoria")
          ],
        ),
      ),
    );
  }
}
