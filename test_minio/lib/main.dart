import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_minio/Login.dart';

import 'RouteGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    initialRoute: "/",
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}


