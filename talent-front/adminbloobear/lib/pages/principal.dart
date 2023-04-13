import 'package:adminbloobear/widgets.dart';
import 'package:flutter/material.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    return Scaffold(
    drawer: Menu(hei: hei, wid: wid),
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
      centerTitle: true,
      title: const Text("Confirmar dirección"),
    ),
    body: const Center(
      child: Text("Soy el admin"),
    ),
  );;
  }
}