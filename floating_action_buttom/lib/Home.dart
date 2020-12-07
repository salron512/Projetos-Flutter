import 'dart:html';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Floating"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endDocked,
      //floatingActionButton: FloatingActionButton(
      floatingActionButton: FloatingActionButton.extended(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: Icon(Icons.add),
        label: Text("teste"),
        //mini: true,
        //child: Icon(Icons.add),
        //onPressed:(){} ,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 6,
        color: Colors.white,
        //shape: CircularNotchedRectangle(),
        child: Row(
          children:<Widget> [
            IconButton(
              onPressed: (){
                
              },
              icon: Icon(Icons.menu),
            )
          ],
        ),
      )
    );
  }
}
