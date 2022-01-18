import 'package:flutter/material.dart';
import 'package:teste/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home() ,
  ));

  int resultado1 = _calcula(11);
  print("resultado " + resultado1.toString());
}

_calcula(int numero) {
  int resultado = 0;
  for (int i = 1; i < numero; i++) {
    if (i % 3 == 0 || i % 5 == 0) {
     // print("numero " + i.toString());
      resultado = resultado + i;
    }
  }

  return resultado;
}
