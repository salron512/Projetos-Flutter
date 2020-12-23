import 'package:flutter/material.dart';
import 'Login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}
