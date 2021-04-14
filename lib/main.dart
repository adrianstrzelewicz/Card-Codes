import 'package:demo_card_codes/RouteNames.dart';
import 'package:demo_card_codes/pages/DisplayCardCodesPage.dart';
import 'package:demo_card_codes/pages/EditCardCodesPage.dart';
import 'package:demo_card_codes/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Card Codes',
    initialRoute: RouteNames.HOME_PAGE,
    routes: {
      RouteNames.HOME_PAGE: (_) => HomePage(),
      RouteNames.DISPLAY_CARD_CODE_PAGE: (_) => DisplayCardCodesPage(),
      RouteNames.EDIT_CARD_CODE_PAGE: (_) => EditCardCodesPage(),
    },
    themeMode: ThemeMode.light,
    darkTheme: ThemeData.dark(),
    theme: ThemeData(
      primaryColor: Color(Colors.blue[700].value),
      primaryColorDark: Color(Colors.blue[800].value),
      accentColor: Colors.orangeAccent,
      primarySwatch: Colors.blue,
    ),
  ),);
}