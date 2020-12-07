import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TelaServico extends StatefulWidget {
  @override
  _TelaServicoState createState() => _TelaServicoState();
}

class _TelaServicoState extends State<TelaServico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Serviços"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [
            Row(
              children:<Widget> [
                Image.asset("images/detalhe_servico.png"),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                    child: Text("Nossos Seriços",
                      style: TextStyle(
                        fontSize: 25
                      ),
                    ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10),
            child: Text("Consultoria",)
            ),
            Padding(padding: EdgeInsets.only(top: 10),
             child: Text("Calculo de preços",)
            ),
            Padding(padding: EdgeInsets.only(top: 10),
                child: Text("Acompanhamento de projetos")
            )
          ],
        ),
      ),
    );
  }
}
