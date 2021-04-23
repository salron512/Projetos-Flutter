import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListaCompras extends StatefulWidget {
  List<dynamic> listaCompras;
  ListaCompras(this.listaCompras);

  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  List<dynamic> _listaRecuperada = [];
  bool _mostraBottomBar = false;
  String _totalCompra = "0";
  _addLista() {
    _listaRecuperada = widget.listaCompras;
    print("tamanho lista " + _listaRecuperada.length.toString());
    double vlrTotal = 0;

    if (_listaRecuperada.length > 0) {
      setState(() {
        _mostraBottomBar = true;
      });
    }

    for (var item in _listaRecuperada) {
      vlrTotal = vlrTotal + double.tryParse(item["precoTotal"]).toDouble();
      setState(() {
        _totalCompra = vlrTotal.toString();
        print("total compras" + _totalCompra);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _addLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho de compras"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8,right: 8, bottom: 5),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          child: Container(
            child: Column(
              children: [
                _listaRecuperada.isEmpty
                    ? Expanded(
                        child: Center(
                        child: Text(
                          "Carrinho de compras está vazio",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ))
                    : Expanded(
                        child: ListView.builder(
                            itemCount: _listaRecuperada.length,
                            itemBuilder: (context, indice) {
                              List produtos = widget.listaCompras;
                              var dados = produtos[indice];
                              return Card(
                                child: ListTile(
                                  leading: Image.network(dados["urlimagem"]),
                                  title: Text(dados["nome"]),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Marca: " + dados["marca"]),
                                      Text(
                                          "Quantidade: " + dados["quantidade"]),
                                      Text("Preco: unitario R\$ " +
                                          dados["precoUnitario"]),
                                      Text("Preço total: R\$ " +
                                          dados["precoTotal"])
                                    ],
                                  ),
                                  trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                 
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                
                                }),
                          ],
                        ),
                                ),
                              );
                            }),
                      ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text("Valor total",
                      style: TextStyle(
                        color: Colors.white, fontSize: 18
                      ),
                      ),
                      subtitle: Text("R\$ " + _totalCompra,
                       style: TextStyle(
                        color: Colors.white, fontSize: 15
                      ),
                      
                      ),
                    ),
                  ),
                ),
                 Visibility(
        visible: _mostraBottomBar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           ElevatedButton(
                  child: Text("Confirmar pedido",
                  style: TextStyle(
                    fontSize: 20
                  ),
                  
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                     padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {},
                )
        ],)
      ),
              ],
            ),
          )),
    );
  }
}
