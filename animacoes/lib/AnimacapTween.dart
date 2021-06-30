import 'package:flutter/material.dart';
import 'dart:ui';

class AnimacapTween extends StatefulWidget {
  const AnimacapTween({Key? key}) : super(key: key);

  @override
  _AnimacapTweenState createState() => _AnimacapTweenState();
}

class _AnimacapTweenState extends State<AnimacapTween> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      /*
      child: TweenAnimationBuilder(
        duration: Duration(seconds: 2),
        tween: Tween<double>(begin: 0, end: 6.28),
        builder: (context, double value, child) {
          return Transform.rotate(
            angle: value,
            child: Image.asset('imagens/logo.png'),
          );
        },
      ),
      
      child: TweenAnimationBuilder(
        duration: Duration(seconds: 5),
        tween: Tween<double>(begin: 50, end: 180),
        builder: (context, double value, child) {
          return Container(
            color: Colors.green,
            width: value,
            height: 60,
          );
        },
      ),
    );
    */

      child: TweenAnimationBuilder(
        duration: Duration(seconds: 2),
        tween: ColorTween(begin: Color(0xff546e7a), end: Color(0xff37474f)),
        builder: (BuildContext context,  cor, child) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.overlay),
            child: Image.asset('imagens/estrelas.jpg'),
          );
        },
      ),
    );
  }
}
