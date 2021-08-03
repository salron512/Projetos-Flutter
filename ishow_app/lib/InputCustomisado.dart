import 'package:flutter/material.dart';

class InputCustomisado extends StatelessWidget {
 

  final String hint;
  final bool obscure;
  final Icon icon;

  InputCustomisado({
    required this.hint,
    required this.obscure,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
            icon: icon,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
            )),
      ),
    );
  }
}
