import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'autocompleteprediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse(this.status, this.predictions);

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      json['status'] as String?,
      json['predictions'] != null
          ? json['predictions']
              .map<AutocompletePrediction>(
                  (json) => AutocompletePrediction.fromJson(json))
              .toList()
          : null,
    );
  }

  static PlaceAutocompleteResponse placeAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}

//--------------------------------------------------Ubicacion de auto--------------------------------------------

class PlaceID {
  final Geometry geometry;

  PlaceID(this.geometry);

  static PlaceID placeId(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceID.fromJson(parsed);
  }

  factory PlaceID.fromJson(Map<String, dynamic> json) {
    return PlaceID(Geometry.fromjson(json["result"]));
  }
}

class Geometry {
  final Location location;

  Geometry(this.location);

  factory Geometry.fromjson(Map<String, dynamic> json) {
    return Geometry(Location.fromjson(json["geometry"]));
  }
}

class Location {
  final Lat lat;

  Location(this.lat);
  factory Location.fromjson(Map<String, dynamic> json) {
    return Location(Lat.fromjson(json["location"]));
  }
}

class Lat {
  final double lati;
  final double longi;

  Lat(this.lati, this.longi);

  factory Lat.fromjson(Map<String, dynamic> json) {
    return Lat(json["lat"] as double, json["lng"] as double);
  }
}
//--------------------------------------------------Ruta--------------------------------------------

class RouteDirection {
  final ListaRouteDirection route;

  RouteDirection(this.route);
  static RouteDirection direction(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return RouteDirection.fromjson(parsed);
  }

  factory RouteDirection.fromjson(Map<String, dynamic> json) {
    return RouteDirection(ListaRouteDirection.fromjson(json["routes"]));
  }
}

class ListaRouteDirection {
  final LegsDirection listroute;

  ListaRouteDirection(this.listroute);

  factory ListaRouteDirection.fromjson(List<dynamic> json) {
    return ListaRouteDirection(LegsDirection.fromjson(json[0]));
  }
}

class LegsDirection {
  final ListLegsDirection legs;

  LegsDirection(this.legs);

  factory LegsDirection.fromjson(Map<String, dynamic> json) {
    return LegsDirection(ListLegsDirection.fromjson(json["legs"]));
  }
}

class ListLegsDirection {
  final DistanceDirection listleg;

  ListLegsDirection(this.listleg);

  factory ListLegsDirection.fromjson(List<dynamic> json) {
    return ListLegsDirection(DistanceDirection.fromjson(json[0]));
  }
}

class DistanceDirection {
  final ValorDistanceDirection distance;
  final List<ListSteps> liststeps;

  DistanceDirection(this.distance, this.liststeps);

  factory DistanceDirection.fromjson(Map<String, dynamic> json) {
    return DistanceDirection(
        ValorDistanceDirection.fromjson(json["distance"]),
        json["steps"]
            .map<ListSteps>((json) => ListSteps.fromjson(json))
            .toList());
  }
}

class ValorDistanceDirection {
  final String distancia;

  ValorDistanceDirection(this.distancia);

  factory ValorDistanceDirection.fromjson(Map<String, dynamic> json) {
    return ValorDistanceDirection(json["text"] as String);
  }
}

class Start {
  final LatLng starp;

  Start(this.starp);

  factory Start.fromjson(Map<String, dynamic> json) {
    return Start(LatLng(json["lat"], json["lng"]));
  }
}

class Dest {
  final LatLng destp;

  Dest(this.destp);

  factory Dest.fromjson(Map<String, dynamic> json) {
    return Dest(LatLng(json["lat"], json["lng"]));
  }
}

class ListSteps {
  final Dest end;
  final Start prin;

  ListSteps(this.end, this.prin);

  factory ListSteps.fromjson(Map<String, dynamic> json) {
    return ListSteps(Dest.fromjson(json["end_location"]),
        Start.fromjson(json["start_location"]));
  }
}
