import 'package:flutter/material.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  String correo = "";

  String contrasena = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
    );
  }

  Widget pantalla(size, context) {
    final double hei = size.height;
    final double wid = size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: hei * 0.3,
          width: wid * 0.8,
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Inicio de Sesión",
              style: TextStyle(fontSize: 100.0, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        SizedBox(
          width: wid * 0.8,
          child: inputC(wid, hei, "Ingresa tu correo"),
        ),
        Padding(padding: EdgeInsets.all(hei * 0.01)),
        SizedBox(
          width: wid * 0.8,
          child: inputN(wid, hei, "Ingresa tu contraseña"),
        ),
        Padding(padding: EdgeInsets.all(hei * 0.01)),
        Center(
          child: botonN(hei, wid, context, "Iniciar sesión", "/Principal"),
        )
      ],
    );
  }

  Widget botonN(hei, wid, context, text, route) {
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
        // print(correo);
        // print(contrasena);
        // var resolt = await Network.isesion(correo, contrasena);
        // print(resolt);
         Navigator.pushNamedAndRemoveUntil(
           context,
           route,
           (route) => false,
         );
      },
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
        setState(() {
          contrasena = value;
        });
      },
    );
  }

  Widget inputC(wid, hei, texto) {
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
        setState(() {
          correo = value;
        });
      },
    );
  }
}
