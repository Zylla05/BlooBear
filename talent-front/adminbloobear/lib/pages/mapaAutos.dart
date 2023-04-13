import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../Styles/mapStyle.dart';
import '../Widgets.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  LatLng inicio = const LatLng(0, 0);
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("Uno"),
        position: const LatLng(19.493853, -99.144253),
        onTap: () {
          setState(() {
            isVisible = true;
            inicio = const LatLng(19.493853, -99.144253);
          });
        },
      ),
      
    };
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    return Scaffold(
      drawer: Menu(hei: hei, wid: wid),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        centerTitle: true,
        title: const Text("Auto Seleccionado"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(mapStyle);
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(19.5015125, -99.1442463), zoom: 14),
            zoomControlsEnabled: false,
          ),
          bottom(context),
        ],
      ),
    );
  }

  Widget bottom(context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.1,
        maxChildSize: 0.25,
        minChildSize: 0.1,
        builder: (context, scrollController) {
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
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: wid * 0.02, vertical: hei * 0.02),
            child: Text(
              "Datos del carro",
              style:
                  TextStyle(fontSize: wid * 0.1, fontWeight: FontWeight.w900),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Padding(
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
                    "Marca del carro",
                    style: estilo,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Padding(
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
                    "Modelo del carro",
                    style: estilo,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Padding(
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
                    "Placa del carro",
                    style: estilo,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Padding(
              padding: EdgeInsets.all(wid * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Tipo de carro:",
                    style: estilo,
                  ),
                  Text(
                    "Tipo del carro",
                    style: estilo,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}
