
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:via_ponto/Login.dart';
import 'package:via_ponto/util/Rotas.dart';

final ThemeData temaPatrao = ThemeData(
  backgroundColor: Colors.green,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Colors.white,
    primary: const Color(0xff20953b),
  ),
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
    home: Login(),
    theme: temaPatrao,
    onGenerateRoute: Rotas.generateRoute,
    initialRoute: "/",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
   
    supportedLocales: [Locale('pt', 'BR')],
  ));
}
