import 'dart:convert';

import 'package:bloobear/Screens/confirmacion.dart';
import 'package:bloobear/Styles/mapStyle.dart';
import 'package:bloobear/autocompleteprediction.dart';
import 'package:bloobear/network.dart';
import 'package:bloobear/placeAutocomplete.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Widgets.dart';

class Buscador extends StatefulWidget {
  final LatLng ini;

  const Buscador({super.key, required this.ini});

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  late int inde;
  late String? future;
  List<AutocompletePrediction> placePredictions = [];
  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json',
        {"input": query, "key": "AIzaSyCryq-_5ADfOEu86wNim22jXNtMpjLpwdA"});
    String? response = await Network.buscador(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.placeAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double hei = size.height;
    final double wid = size.width;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: hei * 0.05, left: wid * 0.02, right: wid * 0.02, bottom: hei*0.02),
            child: Form(child: textfield(hei)),
          ),
          const Divider(
            height: 2,
            thickness: 2,
            color: Color.fromRGBO(105, 159, 183, 1),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTitle(
                press: () {
                  inde = index;
                  function(context);
                },
                location: placePredictions[index].description!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void function(context) async {
    
    future = await Network.destino(placePredictions[inde].placeId!);
    if (future != null) {
      PlaceID res = PlaceID.placeId(future!);
      var noc = res.geometry.location.lat;
      LatLng des = LatLng(noc.lati, noc.longi);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Confirmacion(inicio: widget.ini, fin: des),
          ));
    }
  }

  Widget textfield(hei) {
    return TextFormField(
      onChanged: (value) {
        placeAutocomplete(value);
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
            borderRadius: BorderRadius.circular(5.5)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(105, 159, 183, 1)),
            borderRadius: BorderRadius.circular(5.5)),
        labelText: "Ingrese la Ubicacion",
        labelStyle: TextStyle(
            fontSize: hei * 0.025,
            color: const Color.fromRGBO(76, 108, 132, 1)),
        filled: true,
        fillColor: const Color.fromRGBO(105, 159, 183, 0.3),
      ),
    );
  }
}
