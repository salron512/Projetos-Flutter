import 'dart:io';

import 'package:email/Telas/telaMenu.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(500, 500));
    WindowManager.instance.setMaximumSize(const Size(500, 500));
    
   
  }

  runApp(const MaterialApp(
    home: TelaMenu(),
  ));
}
