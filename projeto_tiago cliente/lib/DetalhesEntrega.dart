import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetalhesEntrega extends StatefulWidget {
  var dados;
  DetalhesEntrega(this.dados);
  @override
  _DetalhesEntregaState createState() => _DetalhesEntregaState();
}

class _DetalhesEntregaState extends State<DetalhesEntrega> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da pedido"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: ListView.separated(
          itemCount: widget.dados.length,
          separatorBuilder: (context, indice) => Divider(
            height: 4,
            color: Colors.grey,
          ),
          itemBuilder: (context, indice) {
            var requisicoes = widget.dados;
            var dados = requisicoes[indice];
            return ListTile( 
              title: Text(
                "Produto: " + dados["nome"],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Marca: " + dados["marca"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "quantidade: " + dados["quantidade"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Preço unitário: R\$: " + dados["precoUnitario"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Preço total: R\$: " + dados["precoTotal"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
