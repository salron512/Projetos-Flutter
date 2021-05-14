import 'package:entrega/Telas/Login.dart';
import 'package:entrega/util/Rotas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final ThemeData temaPatrao = ThemeData(
  primaryColor: Color(0xffFF0000),
  accentColor: Color(0xff8B0000),
  backgroundColor: Colors.grey,
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Login(),
    theme: temaPatrao,
    title: "Projeto Entrega",
    debugShowCheckedModeBanner: false,
    onGenerateRoute: Rotas.generateRoute,
    initialRoute: "/",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [const Locale('pt', 'BR')],
  ));
}
