import 'package:bloobear/Screens/isesion.dart';
import 'package:bloobear/Screens/principal.dart';
import 'package:bloobear/Screens/registro.dart';
import 'package:bloobear/Screens/wellcome.dart';
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
      routes: {
        "/":(context) => const Wellcome(),
        "/Registro":(context) => const Registro(),
        "/ISesion":(context) => const InicioSesion(),
        "/Principal":(context) => const Mapa(),
      },
    );
  }
}

