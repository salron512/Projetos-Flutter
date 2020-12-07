import 'package:entreda_dados/CampoTexto.dart';
import 'package:entreda_dados/EntradaCheckBox.dart';
import 'package:entreda_dados/EntradaRadioButton.dart';
import 'package:entreda_dados/EntradaSlider.dart';
import 'package:entreda_dados/EntradaSwitch.dart';
import 'package:entreda_dados/Lista.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home:CampoTexto() ,
   // home: EntradaCheckbox() ,
    //home: EntradaRadioButton(),
   // home: EntradaSwitch(),
    //home: EntradaSlider(),
    home: Lista(),
  ));
}