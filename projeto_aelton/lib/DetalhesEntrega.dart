import 'package:flutter/material.dart';

class DetalhesEntrega extends StatefulWidget {
  var dados;
  DetalhesEntrega(this.dados);
  @override
  _DetalhesEntregaState createState() => _DetalhesEntregaState();
}

class _DetalhesEntregaState extends State<DetalhesEntrega> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes Entrega"),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: widget.dados.length,
          separatorBuilder: (context, indice) => Divider(
            height: 2,
            color: Colors.grey,
          ),
          itemBuilder: (context, indice) {
            var requisicoes = widget.dados;
            var dados = requisicoes[indice];
            return ListTile(
              title: Text("Produto: " + dados["nome"] ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Marca: " + dados["marca"]),
                  Text("quantidade: " + dados["quantidade"])
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
