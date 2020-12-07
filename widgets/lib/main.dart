import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

int index;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List lista = ["teste", "teste2", "teste3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wiggets"),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: lista.length ,
        itemBuilder:(contex, index){
          final item = lista[index];

          return Dismissible(
            background: Container(
              color: Colors.red,
              child: Row(
                children:<Widget> [
                  Icon(Icons.edit,
                  color: Colors.white,
                  )
                ],
              ),
            ),
            secondaryBackground: Container( color: Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:<Widget> [

                  Icon(Icons.delete,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            //direction: DismissDirection.endToStart,
            onDismissed: (direction){

            },
            key: Key(item),
            child: ListTile(
              title: Text(item),
            ),
          );
        }
      ),

      ),
    );
  }
}
