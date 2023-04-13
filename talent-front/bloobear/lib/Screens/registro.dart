import 'package:bloobear/network.dart';
import 'package:flutter/material.dart';
import '../Styles/const.dart' as constantes;

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  String nombre = "";
  String correo = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bloof.png"),
                  opacity: 0.15,
                ),
              ),
              child: pantalla(size, context),
            ),
          ),
        ),
      ),
    );
  }

  Widget pantalla(size, context) {
    final double hei = size.height;
    final double wid = size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(padding: EdgeInsets.all(hei * 0.1)),
        SizedBox(
          width: wid * 0.8,
          child: inputN(wid, hei, "Ingresa tu nombre"),
        ),
        Padding(padding: EdgeInsets.all(hei * 0.01)),
        SizedBox(
          width: wid * 0.8,
          child: botonR(hei, wid, context, "Enviar"),
        ),
      ],
    );
  }

  Widget inputN(wid, hei, texto) {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
            borderRadius: BorderRadius.circular(5.5)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
            borderRadius: BorderRadius.circular(5.5)),
        labelText: texto,
        labelStyle: TextStyle(
            fontSize: hei * 0.025,
            color: const Color.fromRGBO(76, 108, 132, 1)),
        filled: true,
        fillColor: const Color.fromRGBO(105, 159, 183, 0.3),
      ),
      onChanged: (value) {
        constantes.nombre = value;
      },
    );
  }


  Widget botonR(hei, wid, context, text) {
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
      onPressed: () async {
        Network.registro(context);
        

        //  Navigator.pushNamedAndRemoveUntil(
        //    context,
        //    route,
        //    (route) => false,
        //  );
      },
    );
  }
}
