import 'dart:ui';

import 'package:flutter/material.dart';
import 'InputCustomisado.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
      with SingleTickerProviderStateMixin {

 late AnimationController _controller;
  late Animation<double> _animacaoBlur;
  late Animation<double> _animacaoFade;
  late Animation<double> _animacaoSize;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this
    );

    _animacaoBlur = Tween<double>(
      begin: 5,
      end: 0
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease
    ));

    _animacaoFade = Tween<double>(
        begin: 0,
        end: 1
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuint
    ));

    _animacaoSize = Tween<double>(
        begin: 0,
        end: 500
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate
    ));

    _controller.forward();


  }

  @override
  Widget build(BuildContext context) {

    timeDilation = 8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            AnimatedBuilder(
              animation: _animacaoBlur,
              builder: (context, widget){
                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("imagens/fundo.png"),
                          fit: BoxFit.fill
                      )
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _animacaoBlur.value,
                        sigmaY: _animacaoBlur.value
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          child: FadeTransition(
                            opacity: _animacaoFade,
                            child: Image.asset("imagens/detalhe1.png"),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          child: FadeTransition(
                            opacity: _animacaoFade,
                            child: Image.asset("imagens/detalhe2.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(children: <Widget>[
                AnimatedBuilder(
                  animation: _animacaoSize,
                  builder: (context, widget){
                    return Container(
                      width: _animacaoSize.value,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15,
                                spreadRadius: 4
                            )
                          ]
                      ),
                      child: Column(children: <Widget>[
                        
                       InputCustomisado(
                          hint: "Email",
                          obscure: false,
                          icon: Icon(Icons.person),
                        ),
                        InputCustomisado(
                          hint: "Senha",
                          obscure: true,
                          icon: Icon(Icons.lock),
                        )
                      ],),
                    );
                  },
                ),
                SizedBox(height: 20,),
                AnimatedBuilder(
                  animation: _animacaoSize,
                  builder: (context, widget){
                    return InkWell(
                      onTap: (){

                      },
                      child: Container(
                        height: 50,
                        width: _animacaoSize.value,
                        child: Center(
                          child: Text("Entrar", style: TextStyle(
                              color: Colors.white, fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 100, 127, 1),
                                  Color.fromRGBO(255, 123, 145, 1),
                                ]
                            )
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10,),
                FadeTransition(
                  opacity: _animacaoFade,
                  child: Text("Esqueci minha senha!", style: TextStyle(
                      color: Color.fromRGBO(255, 100, 127, 1),
                      fontWeight: FontWeight.bold
                  ),),
                )

              ],),
            )
          ],),
        ),
      ),
    );
  }
}
