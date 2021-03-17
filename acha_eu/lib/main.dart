import 'package:acha_eu/telas/Home.dart';
import 'package:acha_eu/util/RouteGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a),
  backgroundColor: Colors.grey,
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    // debugShowCheckedModeBanner: false,
    title: "acha eu",
    theme:temaPadrao ,
    home: Home(),
    initialRoute: "/",
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
