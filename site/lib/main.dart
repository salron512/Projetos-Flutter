import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:site/telas/Home.dart';
import 'package:site/util/RouteGenerator.dart';


final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a),
);
void main()async {
 WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "Site",
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
    home: Home(),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [const Locale('pt', 'BR')],
  ));
}
