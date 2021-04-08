import 'package:acha_eu/telas/Home.dart';
import 'package:acha_eu/util/RouteGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a),
  backgroundColor: Colors.grey,
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.init("873ffd12-752e-4659-8fd8-99cc8174678b", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);

  runApp(MaterialApp(
    // debugShowCheckedModeBanner: false,
    title: "Chama Eu",
    theme:temaPadrao ,
    debugShowCheckedModeBanner: false,
    home: Home(),
    initialRoute: "/",
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('pt', 'BR')
    ],
  ));
}
