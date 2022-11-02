import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_mobx/Counter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final _counter = Counter();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobX'),
      ),
      body: Observer(
      
        builder: ((_) {
          return Center(child: Text("${_counter.index}",
          style: const TextStyle(
              fontSize: 25
          ),
          ));
        }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            _counter.increment();
          }),
          child: const Icon(Icons.add)),
    );
  }
}
