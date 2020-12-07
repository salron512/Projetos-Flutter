import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navegacao/TelaSecundaria.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/secundaria":(contex) => TelaSecundaria()
    },
    home: TelaPrincipal() ,
  )
  );
}
class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Principal"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children:<Widget> [
            RaisedButton(
                child: Text("Ir para a segunda tela"),
                onPressed: (){
                  Navigator.pushNamed(context, "/secundaria");



                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaSecundaria()
                      ),
                  );*/
                }
            )
          ],
        ),
      ) ,
    );
  }
}
