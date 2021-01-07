import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;

  _usuarioLogin() async {
    String email = "andre.vicensotti@gmail.com";
    String password = "12345678";

    await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = await auth.currentUser.uid;
    auth.currentUser.getIdToken().then((IdTokenResult) {
      print("Token: " + IdTokenResult);
    }).catchError((erro) {});
  }

  _inserirJson() async {
    var url = "https://lista-albuns-default-rtdb.firebaseio.com/artista.json";
    http.Response response = await http.get(url);
    Map<String, dynamic> dadosJson = json.decode(response.body);

    print("resposta: " + response.statusCode.toString());
    print("resposta: " + dadosJson.toString());
    print("resposta filtro: " + dadosJson["Mike Shinoda"]["album2"].toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usuarioLogin();
    _inserirJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [Text("login")],
          ),
        ),
      ),
    );
  }
}
