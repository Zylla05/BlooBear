import 'dart:math';

import 'package:bloobear/Screens/rutaACarro.dart';
import 'package:bloobear/directionprovider.dart';
import 'package:bloobear/network.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import '../Styles/const.dart' as paymentconfig;
import 'package:pay/pay.dart';

import '../Styles/mapStyle.dart';
import '../Widgets.dart';

class Confirmacion extends StatefulWidget {
  const Confirmacion({super.key, required this.inicio, required this.fin});
  final LatLng inicio;
  final LatLng fin;

  @override
  State<Confirmacion> createState() => _ConfirmacionState();
}

class _ConfirmacionState extends State<Confirmacion> {
  LatLng yo = const LatLng(0, 0);
  String distancia = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    Set<Marker> markers = {
      Marker(markerId: const MarkerId("Inicio"), position: widget.inicio),
      Marker(markerId: const MarkerId("fin"), position: widget.fin)
    };
    double mediolat = (widget.inicio.latitude + widget.fin.latitude) / 2;
    double mediolong = (widget.inicio.longitude + widget.fin.longitude) / 2;
    LatLng medio = LatLng(mediolat, mediolong);
    return Scaffold(
      drawer: Menu(hei: hei, wid: wid),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(105, 159, 183, 1),
        centerTitle: true,
        title: const Text("Confirmar dirección"),
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
                      await api.findDirections(widget.inicio, widget.fin);

                      var left =
                          min(widget.inicio.latitude, widget.fin.latitude);
                      var right =
                          max(widget.inicio.latitude, widget.fin.latitude);
                      var top =
                          max(widget.inicio.longitude, widget.fin.longitude);
                      var button =
                          min(widget.inicio.longitude, widget.fin.longitude);

                      distancia = api.distancia;

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

  List<PaymentItem> get paymentItem {
    const _paymentItems = [
      PaymentItem(
          amount: "10", label: "Total", status: PaymentItemStatus.final_price)
    ];
    return _paymentItems;
  }

  Widget barraconfirm(context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.15,
      maxChildSize: 0.25,
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
    String fin = "Distancia total: $distancia";
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
                horizontal: wid * 0.05, vertical: hei * 0.01),
            child: Text(
              fin,
              style: estilo,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: wid * 0.05, vertical: hei * 0.01),
            child: GooglePayButton(
              paymentConfiguration: PaymentConfiguration.fromJsonString(
                  paymentconfig.defaultGooglePay),
              paymentItems: paymentItem,
              onPaymentResult: onGooglePayResult,
              type: GooglePayButtonType.pay,
              width: wid * 0.8,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: wid * 0.05, vertical: hei * 0.01),
            child: botonN(hei, wid, context, "Pay with Solana"),
          )
        ],
      ),
    );
  }

  void onGooglePayResult(paymentResult) async {
    await getUserLocation();
    var res = Network.renta();
    if (res != null) {
      
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ACarro(
            fin: widget.fin,
            inicio: widget.inicio,
            yo: yo,
          ),
        ));
    }
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
        await getUserLocation();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ACarro(
                fin: widget.fin,
                inicio: widget.inicio,
                yo: yo,
              ),
            ));
      },
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    yo = LatLng(position.latitude, position.longitude);
  }
}
