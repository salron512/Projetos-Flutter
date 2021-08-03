import 'package:flutter/material.dart';
import 'package:ishow_app/InputCustomisado.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/fundo.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: [
                    Positioned(
                        left: 10, child: Image.asset('images/detalhe1.png')),
                    Positioned(
                        left: 50, child: Image.asset('images/detalhe2.png')),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 15,
                                spreadRadius: 4)
                          ]),
                      child: Column(
                        children: [
                          InputCustomisado(
                              hint: "Email",
                              obscure: false,
                              icon: Icon(Icons.person)),
                          InputCustomisado(
                              hint: "Senha",
                              obscure: false,
                              icon: Icon(Icons.lock)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // InkWell(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Esqueci minha senha! ",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 100, 127, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
