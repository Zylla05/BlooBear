import 'dart:math';
import 'package:bloobear/directionprovider.dart';
import 'package:bloobear/network.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Styles/mapStyle.dart';

class RFinal extends StatefulWidget {
  const RFinal(
      {super.key, required this.inicio, required this.fin, required this.yo});
  final LatLng inicio;
  final LatLng fin;
  final LatLng yo;

  @override
  State<RFinal> createState() => _RFinalState();
}

class _RFinalState extends State<RFinal> {
  int cont = 2;
  bool permitidoPuerta = true;
  bool permitidoArranque = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    Set<Marker> markers = {
      Marker(markerId: const MarkerId("Fin"), position: widget.fin),
    };
    TextStyle estilo =
        TextStyle(fontWeight: FontWeight.bold, fontSize: hei * 0.03);
    TextStyle estiloSi = TextStyle(
        fontWeight: FontWeight.bold, fontSize: hei * 0.03, color: Colors.green);
    TextStyle estiloNo = TextStyle(
        fontWeight: FontWeight.bold, fontSize: hei * 0.03, color: Colors.red);
    final ButtonStyle estiloboton = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        shadowColor: const Color.fromRGBO(76, 108, 132, 1),
        minimumSize: Size(wid * 0.8, hei * 0.03),
        maximumSize: Size(wid * 0.8, hei * 0.06),
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))));
    double mediolat = (widget.inicio.latitude + widget.fin.latitude) / 2;
    double mediolong = (widget.inicio.longitude + widget.fin.longitude) / 2;
    LatLng medio = LatLng(mediolat, mediolong);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        centerTitle: true,
        title: const Text("Ruta hacia su destino"),
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
                      await api.findDirections(widget.yo, widget.fin);

                      var left = min(widget.yo.latitude, widget.fin.latitude);
                      var right = max(widget.yo.latitude, widget.fin.latitude);
                      var top = max(widget.yo.longitude, widget.fin.longitude);
                      var button =
                          min(widget.yo.longitude, widget.fin.longitude);

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
                  DraggableScrollableSheet(
                    initialChildSize: 0.1,
                    minChildSize: 0.1,
                    maxChildSize: 0.3,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: wid * 0.05,
                                    vertical: hei * 0.015),
                                child: Expanded(
                                  child: Center(
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: hei * 0.01),
                                            child: Text(
                                              "Status del carro",
                                              style: estilo,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: hei * 0.01),
                                            child: Text(
                                              "Puertas",
                                              style: estilo,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: hei * 0.02),
                                            child: Text(
                                              permitidoPuerta
                                                  ? "Abiertas"
                                                  : "Cerradas",
                                              style: permitidoPuerta
                                                  ? estiloSi
                                                  : estiloNo,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: hei * 0.01),
                                            child: Text(
                                              "Arranque",
                                              style: estilo,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: hei * 0.02),
                                            child: Text(
                                              permitidoArranque
                                                  ? "Permitido"
                                                  : "Cancelado",
                                              style: permitidoArranque
                                                  ? estiloSi
                                                  : estiloNo,
                                            ),
                                          )
                                        ],
                                      ),
                                      ElevatedButton(
                                        style: estiloboton,
                                        child: const FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Cambiar estado",
                                            style: const TextStyle(
                                                fontSize: 100.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          var cambio = Network.cambio();
                                          if (cambio != null) {
                                            setState(() {
                                              if (cont == 2) {
                                                permitidoArranque =
                                                    !permitidoArranque;
                                              }
                                              if (cont == 3) {
                                                permitidoArranque =
                                                    !permitidoArranque;
                                              }
                                              if (cont == 4) {
                                                permitidoPuerta =
                                                    !permitidoPuerta;
                                              }
                                              cont++;
                                            });
                                          }
                                        },
                                      )
                                    ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
