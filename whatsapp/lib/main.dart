import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Home.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  // ignore: deprecated_member_use
  Firestore.instance.collection("usuarios").document("001").setData({
    "nome": "André"
  });

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home() ,
  ));
}
