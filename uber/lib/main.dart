import 'package:flutter/material.dart';
import 'RouteGenerator.dart';
import 'telas/Home.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a),
);

void main() {
  runApp(MaterialApp(
    title: "Uber",
    theme: temaPadrao,
    home: Home(),
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
