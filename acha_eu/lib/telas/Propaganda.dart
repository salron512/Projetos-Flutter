import 'package:flutter/material.dart';

class Propaganda extends StatefulWidget {
  @override
  _PropagandaState createState() => _PropagandaState();
}

class _PropagandaState extends State<Propaganda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Propaganda"),
      ),
      body: Center(
        child: Text("Propaganda"),
      ),
    );
  }
}
