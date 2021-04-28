import 'package:acha_eu/telas/Home.dart';
import 'package:acha_eu/telas/ListaCategorias.dart';
import 'package:acha_eu/util/RouteGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    title: "Chama Eu",
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
    home: ListaCategorias(),
    initialRoute: "/",
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [const Locale('pt', 'BR')],
  ));
}
