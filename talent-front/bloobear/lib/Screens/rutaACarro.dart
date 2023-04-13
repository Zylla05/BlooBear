import 'dart:math';
import 'package:bloobear/Screens/rutaFinal.dart';
import 'package:bloobear/directionprovider.dart';
import 'package:bloobear/network.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

import '../Styles/mapStyle.dart';
import '../Widgets.dart';

class ACarro extends StatefulWidget {
  const ACarro(
      {super.key, required this.inicio, required this.fin, required this.yo});
  final LatLng inicio;
  final LatLng fin;
  final LatLng yo;

  @override
  State<ACarro> createState() => _ACarroState();
}

class _ACarroState extends State<ACarro> {
  LatLng yo2 = LatLng(0, 0);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    Set<Marker> markers = {
      Marker(markerId: const MarkerId("Inicio"), position: widget.inicio),
    };
    double mediolat = (widget.inicio.latitude + widget.fin.latitude) / 2;
    double mediolong = (widget.inicio.longitude + widget.fin.longitude) / 2;
    LatLng medio = LatLng(mediolat, mediolong);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        centerTitle: true,
        title: const Text("Ruta hacia el vehiculo"),
      ),
      body: ChangeNotifierProvider(
        create: (_) => DirectionProvider(),
        child: SizedBox(
          width: wid,
          height: hei,
          child: Expanded(
            child: Consumer(
              builder: (BuildContext context, DirectionProvider api, child) {
                return Stack(children: [
                  GoogleMap(
                    markers: markers,
                    polylines: api.currentRoute,
                    onMapCreated: (GoogleMapController controller) async {
                      await controller.setMapStyle(mapStyle);
                      await controller.getVisibleRegion();

                      var api = Provider.of<DirectionProvider>(context,
                          listen: false);
                      await api.findDirections(widget.yo, widget.inicio);

                      var left =
                          min(widget.yo.latitude, widget.inicio.latitude);
                      var right =
                          max(widget.yo.latitude, widget.inicio.latitude);
                      var top =
                          max(widget.yo.longitude, widget.inicio.longitude);
                      var button =
                          min(widget.yo.longitude, widget.inicio.longitude);

                      api.currentRoute.first.points.forEach((point) {
                        left = min(left, point.latitude);
                        right = max(right, point.latitude);
                        top = max(top, point.longitude);
                        button = min(button, point.longitude);
                      });

                      var bounds = LatLngBounds(
                          southwest: LatLng(left, button),
                          northeast: LatLng(right, top));
                      var cameraUpdate =
                          CameraUpdate.newLatLngBounds(bounds, 100);
                      await controller.animateCamera(cameraUpdate);
                    },
                    initialCameraPosition:
                        CameraPosition(target: medio, zoom: 14),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                  ),
                  barraconfirm(context),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget barraconfirm(context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.1,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: confirm(context, scrollController),
        );
      },
    );
  }

  Widget confirm(context, scrollController) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    TextStyle estilo =
        TextStyle(fontWeight: FontWeight.bold, fontSize: hei * 0.03);
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: wid * 0.05, vertical: hei * 0.015),
            child: botonN(hei, wid, context, "Desbloquear auto"),
          )
        ],
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
      onPressed: () async {
        var res =Network.cambio();
        if (res != null) {
          
        await getUserLocation();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RFinal(
                inicio: widget.inicio,
                fin: widget.fin,
                yo: yo2,
              ),
            ));
        }
      },
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    yo2 = LatLng(position.latitude, position.longitude);
  }
}
