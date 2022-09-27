import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/pages/home_page.dart';
import 'package:validacion_formularios/src/pages/login_page.dart';
import 'package:validacion_formularios/src/pages/producto_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'login': (BuildContext context) => const LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => const ProductoPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
