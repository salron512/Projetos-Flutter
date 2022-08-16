import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  CheckList({Key? key}) : super(key: key);

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  final StreamController _streamController = StreamController.broadcast();


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
