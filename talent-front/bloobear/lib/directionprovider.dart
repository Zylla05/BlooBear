import 'dart:convert';
import 'Styles/const.dart' as constantes;
import 'package:bloobear/network.dart';
import 'package:bloobear/placeAutocomplete.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

class DirectionProvider extends ChangeNotifier {
  // GoogleMapsDirections directionsApi =
  // GoogleMapsDirections(apiKey: "AIzaSyCryq-_5ADfOEu86wNim22jXNtMpjLpwdA");

  Set<maps.Polyline> _route = Set();
  Set<maps.Polyline> get currentRoute => _route;
  String distancia = "";

  findDirections(maps.LatLng from, maps.LatLng to) async {
    var result = await Network.ruta(
        from.latitude, from.longitude, to.latitude, to.longitude);
    Set<maps.Polyline> newRoute = Set();
    if (result != null) {
      RouteDirection res = RouteDirection.direction(result);
      distancia = res.route.listroute.legs.listleg.distance.distancia;
      var step = res.route.listroute.legs.listleg.liststeps;

      // var route = result.routes[0];
      // var leg = route.legs[0];
      List<maps.LatLng> points = [];
      step.forEach((element) {
        points.add(element.prin.starp);
        points.add(element.end.destp);
      });
      var line = maps.Polyline(
          points: points,
          polylineId: const maps.PolylineId("Ruta"),
          color: const Color.fromRGBO(105, 159, 183, 1),
          width: 4);
      newRoute.add(line);
      _route = newRoute;
      notifyListeners();
    }
  }
}

class UbicacionProvider extends ChangeNotifier {
  final Map<maps.MarkerId, maps.Marker> _markers = {};
  Set<maps.Marker> get markers => _markers.values.toSet();
  String marca = "";
  String modelo = "";
  String placa = "";
  maps.LatLng ubi = maps.LatLng(0, 0);

  findAutos(data) {
    final responde = Ubicacion.fromjson(data);
    String id = responde.id.toString();
    final markerid = maps.MarkerId(id);
    final marker = maps.Marker(
      markerId: markerid,
      position: maps.LatLng(responde.lat, responde.log),
      onTap: () async {
        var resolt = await Network.idAuto(id);
        var autito =
            Auto.fromjson(json.decode(resolt!).cast<String, dynamic>());
        marca = autito.marca;
        modelo = autito.modelo;
        placa = autito.placa;
        ubi = maps.LatLng(responde.lat, responde.log);
        constantes.id = responde.id;
        notifyListeners();
      },
    );
    _markers[markerid] = marker;
    notifyListeners();
  }
}

class Ubicacion {
  final lat;
  final log;
  final id;

  Ubicacion(this.lat, this.log, this.id);
  factory Ubicacion.fromjson(Map<String, dynamic> json) {
    return Ubicacion(json["alt"], json["lat"], json["id"]);
  }
}

class Auto {
  final marca;
  final modelo;
  final placa;

  Auto(this.marca, this.modelo, this.placa);
  factory Auto.fromjson(Map<String, dynamic> json) {
    return Auto(json["brand"], json["model"], json["plate"]);
  }
}
