import 'package:entrega/Telas/Login.dart';
import 'package:entrega/util/Rotas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final ThemeData temaPatrao = ThemeData(
  primaryColor: Color(0xffFF0000),
  backgroundColor: Colors.blue,
  colorScheme: ColorScheme.fromSwatch().copyWith( 
  secondary: Color(0xff8B0000),
  primary: Color(0xffFF0000),
  ),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  

  OneSignal.shared.init("b376574d-1c7d-4e81-ac36-47c68468ae6e", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
// The promptForPushNotificationsWithUserResponse function
// will show the iOS push notification prompt. We recommend
// removing the following code and instead using an
// In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  runApp(MaterialApp(
    home: Login(),
    theme: temaPatrao,
    title: "Projeto Entrega",
    debugShowCheckedModeBanner: false,
    onGenerateRoute: Rotas.generateRoute,
    initialRoute: "/",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [const Locale('pt', 'BR')],
  ));
}
