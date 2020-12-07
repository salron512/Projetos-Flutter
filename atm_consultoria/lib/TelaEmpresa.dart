import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaEmpresa extends StatefulWidget {
  @override
  _TelaEmpresaState createState() => _TelaEmpresaState();
}

class _TelaEmpresaState extends State<TelaEmpresa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Empresa"),
      ),
      body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children:<Widget> [
            Row(
              children:<Widget> [
                Image.asset("images/detalhe_empresa.png"),
               Padding(
                   child:  Text("Sobre a Empresa",
                     style: TextStyle(
                         color: Colors.deepOrange,
                         fontSize: 25
                     ),
                   ),
                   padding: EdgeInsets.only(left: 10))
              ],
            ),
            Padding(
                child: Text("Contrary to popular belief, Lorem Ipsum is not "
                    "simply random text. It has roots in a piece of classical "
                    "Latin literature from 45 BC, making it over 2000 years old. Richard "
                    "McClintock, a Latin professor at Hampden-Sydney College in"
                    " Virginia, looked up the more obscure Latin words, consectetur,"
                    " from a Lorem Ipsum passage, and going through the cites of "
                    "the word in classical literature, discovered the undoubtable "
                    "source. Lorem Ipsum There are many variations of passages of "
                    "Lorem Ipsum available, but the majority have suffered alteration "
                    "in some form, by injected humour, or randomised words "
                    "which don't look even slightly"
                    "Contrary to popular belief, Lorem Ipsum is not "
                    "simply random text. It has roots in a piece of classical "
                    "Latin literature from 45 BC, making it over 2000 years old. Richard "
                    "McClintock, a Latin professor at Hampden-Sydney College in"
                    " Virginia, looked up the more obscure Latin words, consectetur,"
                    " from a Lorem Ipsum passage, and going through the cites of "
                    "the word in classical literature, discovered the undoubtable "
                    "source. Lorem Ipsum There are many variations of passages of "
                    "Lorem Ipsum available, but the majority have suffered alteration "
                    "in some form, by injected humour, or randomised words "
                    "which don't look even slightly",
                  style: TextStyle(
                      fontSize: 22
                  ),
                ),
                padding: EdgeInsets.only(top: 16))
          ],
        ),
      ),
      )
      );
  }
}
