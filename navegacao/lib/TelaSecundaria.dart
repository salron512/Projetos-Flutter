import 'package:flutter/material.dart';

class TelaSecundaria extends StatefulWidget {




  @override
  _TelaSecundariaState createState() => _TelaSecundariaState();
}

class _TelaSecundariaState extends State<TelaSecundaria> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Segundaria"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children:<Widget> [
            Text("Tela Segundaria, "),
            RaisedButton(
                child: Text("Ir para a primeira tela"),
                onPressed: (){
                  Navigator.pushNamed(context, "/");



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
