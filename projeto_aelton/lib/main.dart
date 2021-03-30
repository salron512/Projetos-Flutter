import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aelton/util/RouteGenerator.dart';

import 'Login.dart';


final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xffFF0000),
    accentColor: Color(0xff8B0000),

);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Login() ,
    debugShowCheckedModeBanner: false,
    title: "cesta",
    theme: temaPadrao,
    initialRoute: "/",
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
