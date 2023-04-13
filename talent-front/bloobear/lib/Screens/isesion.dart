import 'package:bloobear/Screens/principal.dart';
import 'package:bloobear/network.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Styles/const.dart' as constantes;
import 'package:geolocator/geolocator.dart';

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
    var correo = constantes.correo;
    final double hei = size.height;
    final double wid = size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: wid * 0.8,
          child:
              inputC(wid, hei, "Ingresa el codigo enviado al correo $correo"),
        ),
        Padding(padding: EdgeInsets.all(hei * 0.01)),
        Center(
          child: botonN(hei, wid, context, "Enviar"),
        )
      ],
    );
  }

  Widget botonN(hei, wid, context, text) {
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
        getUserLocation();
        // print(correo);
        // print(contrasena);
        Network.init(context);
        // print(resolt);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Mapa(),
        //     ));
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
      onChanged: (value) async {
        getUserLocation();
        constantes.code = value;
      },
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    constantes.ubiac = LatLng(position.latitude, position.longitude);
  }
}
