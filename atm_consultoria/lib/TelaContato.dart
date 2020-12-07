import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaContato extends StatefulWidget {
  @override
  _TelaContatoState createState() => _TelaContatoState();
}

class _TelaContatoState extends State<TelaContato> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Contato"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [
            Row(
              children:<Widget> [
                Image.asset("images/detalhe_contato.png"),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("Contato",
                    style: TextStyle(
                        fontSize: 25
                    ),
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10),
                child: Text("E-mail: andre.viecensotti@gmail.com",)
            ),
            Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Telefone: (65) 9999-6666",)
            ),
            Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Celular: (65) 99690-2807")
            )
          ],
        ),
      ),
    );
  }
}
