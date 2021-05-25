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
                "Produto: " + dados["produto"],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "quantidade: " + dados["qtd"].toString(),
                  ),
                  Text(
                    "Preço unitário: R\$: " + dados["precoUnitario"].toString(),
                  ),
                  Text(
                    "Preço total: R\$: " + dados["precoTotal"].toString(),
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
