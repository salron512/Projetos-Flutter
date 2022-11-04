import 'package:flutter/material.dart';
import 'package:teste_mobx/Home.dart';


final ThemeData themeDefault = ThemeData(
  //primaryColor: const Color(0xff202125),
  colorScheme: ColorScheme.fromSwatch().copyWith( 
  secondary: Colors.white,
  primary:const Color(0xff202125),
  ),
);

void main() {
  runApp(
     MaterialApp(
    home: const Home(),
    theme: themeDefault,
    debugShowCheckedModeBanner: false,
  ));
}

