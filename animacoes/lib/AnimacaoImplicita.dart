import 'package:flutter/material.dart';

class AnimacaoImplicita extends StatefulWidget {
  @override
  _AnimacaoImplicitaState createState() => _AnimacaoImplicitaState();
}

class _AnimacaoImplicitaState extends State<AnimacaoImplicita> {
  bool _status = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.bounceOut,
          padding: EdgeInsets.all(20),
          width: _status ? 200 : 300,
          height: _status ? 200 : 300,
          color: _status? Colors.purpleAccent: Colors.blue,
          child: Image.asset('imagens/logo.png'),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _status = !_status;
              });
            },
            child: Text("Alterar"))
      ],
    );
  }
}
