import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';

import 'util/RouteGenerator.dart';


final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xffFF0000),
  accentColor: Color(0xff174076),
 // primaryColor: Color(0xff174076),
 // accentColor: Color(0xffd32337),
 
);

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.init("98b0698b-f0a2-4843-be0a-fd358da3bda1", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
    title: "cesta",
    theme: temaPadrao,
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
