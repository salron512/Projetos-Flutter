import 'package:acha_eu/util/Localizacao.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TelaErro extends StatefulWidget {
  @override
  _TelaErroState createState() => _TelaErroState();
}

class _TelaErroState extends State<TelaErro> {
  _verificaPermissao() async {
    Localizacao.verificaLocalizacao();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied
     || permission !=  LocationPermission.deniedForever
    ) {
     Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Erro"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              child: Image.asset("images/gear.png"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Você precisa permitir que o app acesse sua localização",
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(
              child: Text(
                "Permitir",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff37474f),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
              ),
              onPressed: () {
                _verificaPermissao();
              },
            )
          ],
        ),
      ),
    );
  }
}
