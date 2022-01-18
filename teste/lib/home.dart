// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  

  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text("teste"),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              
              Text("teste",
          style: TextStyle(
            fontSize: 20
          ),
          ),
          FloatingActionButton(
            
            onPressed: (){

          })
            ],
          )
        ),
      ),
      
    );
  }
}