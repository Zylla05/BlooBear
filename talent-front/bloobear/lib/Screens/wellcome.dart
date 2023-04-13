import 'package:bloobear/Screens/isesion.dart';
import 'package:bloobear/Screens/principal.dart';
import 'package:bloobear/network.dart';

import '../Styles/const.dart' as constant;
import 'package:flutter/material.dart';

class Wellcome extends StatelessWidget {
  const Wellcome({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: pantalla(size, context),
      ),
    );
  }
}

Widget pantalla(size, context) {
  final double hei = size.height;
  final double wid = size.width;

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Positioned(
          child: Image.asset(
            "assets/images/bloobear.png",
            height: hei * 0.3,
            width: wid * 1.0,
          ),
        ),
        SizedBox(
          height: hei * 0.05,
          width: wid * 0.7,
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Ingrese su correo electronico",
              style: TextStyle(fontSize: 100.0, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: wid * 0.05, vertical: hei * 0.01),
          child: Center(
            child: input(wid, hei, "Correo electronico"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: wid * 0.05, vertical: hei * 0.01),
          child: Center(
            child: boton(hei, wid, context, "Enviar"),
          ),
        ),
      ],
    ),
  );
}

Widget input(wid, hei, texto) {
  return TextFormField(
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
          borderRadius: BorderRadius.circular(5.5)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
          borderRadius: BorderRadius.circular(5.5)),
      labelText: texto,
      labelStyle: TextStyle(
          fontSize: hei * 0.025, color: const Color.fromRGBO(76, 108, 132, 1)),
      filled: true,
      fillColor: const Color.fromRGBO(105, 159, 183, 0.3),
    ),
    onChanged: (value) {
      constant.correo = value;
    },
  );
}

Widget boton(
  hei,
  wid,
  context,
  text,
) {
  final ButtonStyle estiloboton = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
      shadowColor: const Color.fromRGBO(76, 108, 132, 1),
      minimumSize: Size(wid * 0.8, hei * 0.03),
      maximumSize: Size(wid * 0.8, hei * 0.06),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))));
  return ElevatedButton(
    style: estiloboton,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: const TextStyle(fontSize: 100.0),
      ),
    ),
    onPressed: () {
      Network.login(context);
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   route,
      //   (route) => false,
      // );
      //  Navigator.push(
      //        context,
      //        MaterialPageRoute(
      //          builder: (context) => const Mapa()
      //          ,
      //        ));
    },
  );
}

//final ButtonStyle estiloboton = ElevatedButton.styleFrom( );
