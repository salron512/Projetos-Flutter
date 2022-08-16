import 'package:atendimento/Entrar.dart';
import 'package:atendimento/util/Rotas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';


final ThemeData temaPatrao = ThemeData(
  primaryColor: const Color.fromARGB(255, 108, 85, 236),
  backgroundColor:  Colors.blue,
  colorScheme: ColorScheme.fromSwatch().copyWith( 
  secondary: Colors.white,
  primary: const Color.fromARGB(255, 28, 30, 146),
  ),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: Entrar(),
    theme: temaPatrao,
    onGenerateRoute: Rotas.generateRoute,
    initialRoute: "/",
    // ignore: prefer_const_literals_to_create_immutables
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [Locale('pt', 'BR')],
  ));
}
