import 'package:adminbloobear/pages/isesion.dart';
import 'package:adminbloobear/pages/principal.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlooBear',
      initialRoute: "/",
      routes:{
        "/":(context) => const InicioSesion(),
        "/Principal":(context) => const Principal(),
      } ,
      
    );
  }
}