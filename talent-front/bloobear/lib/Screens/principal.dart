import 'package:bloobear/Screens/buscador.dart';
import 'package:bloobear/network.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Styles/mapStyle.dart';
import '../Widgets.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import '../Styles/const.dart' as constantes;
import "../directionprovider.dart";
import '../Styles/const.dart' as constant;

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  var sockapi;
  final IO.Socket _socket = IO.io("http://10.14.1.157:3001/client",
      IO.OptionBuilder().setTransports(["websocket"]).build());
  _conection() {
    _socket.onConnect((data) {
      print("Coneccion exitosa");
      _socket.emit("info", {"id": 0});
    });
    _socket.onDisconnect((data) => print("Coneccion perdida"));
    _socket.onConnectError((data) => print("$data"));
    _socket.on("ubi", (data) {
      var api = Provider.of<UbicacionProvider>(sockapi, listen: false);
      api.findAutos(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _conection();
  }

  LatLng inicio = const LatLng(0, 0);
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    return ChangeNotifierProvider<UbicacionProvider>(
      create: (_) => UbicacionProvider(),
      child: Scaffold(
        drawer: Menu(hei: hei, wid: wid),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
          centerTitle: true,
          title: const Text("Seleccione un auto disponible"),
        ),
        body: SizedBox(
          width: wid,
          height: hei,
          child: Stack(
            children: <Widget>[
              Consumer<UbicacionProvider>(
                  builder: (context, controller, child) {
                sockapi = context;
                return Stack(children: [
                  GoogleMap(
                    markers: controller.markers,
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(mapStyle);
                    },
                    initialCameraPosition:
                        CameraPosition(target: constantes.ubiac, zoom: 14),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                  ),
                  bottom(context),
                ]);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottom(contexto) {
    return DraggableScrollableSheet(
        initialChildSize: 0.1,
        maxChildSize: 0.35,
        minChildSize: 0.1,
        builder: (contexto, scrollController) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: datos(context, scrollController),
          );
        });
  }

  Widget datos(context, scrollController) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    TextStyle estilo = const TextStyle(fontWeight: FontWeight.bold);
    return ChangeNotifierProvider<UbicacionProvider>(
      create: (_) => UbicacionProvider(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Consumer<UbicacionProvider>(builder: (context, value, child) {
          var api = Provider.of<UbicacionProvider>(sockapi, listen: false);
          inicio = api.ubi;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: wid * 0.02, vertical: hei * 0.02),
                child: Text(
                  "Datos del carro",
                  style: TextStyle(
                      fontSize: wid * 0.1, fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(wid * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Marca del carro:",
                      style: estilo,
                    ),
                    Text(
                      api.marca,
                      style: estilo,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(wid * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Modelo del carro:",
                      style: estilo,
                    ),
                    Text(
                      api.modelo,
                      style: estilo,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(wid * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Placa del carro:",
                      style: estilo,
                    ),
                    Text(
                      api.placa,
                      style: estilo,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: wid * 0.01, vertical: hei * 0.015),
                child: botonN(hei, wid, context, "Seleccionar"),
              )
            ],
          );
        }),
      ),
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
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Buscador(ini: inicio),
          ),
          (route) => false,
        );
      },
    );
  }
}
