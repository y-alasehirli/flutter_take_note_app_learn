import 'package:bolum28_notsepeti_app/const/sett.dart';
import 'package:bolum28_notsepeti_app/pages/main_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Setts.mainTheme,
      debugShowCheckedModeBanner: false,
      title: 'Not Sepeti',
      home: MainPage()
    );
  }
}
