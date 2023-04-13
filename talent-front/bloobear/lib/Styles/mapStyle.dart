import 'dart:convert';

const String key = "AIzaSyCryq-_5ADfOEu86wNim22jXNtMpjLpwdA";

const _mapStyle = [
  {
    "featureType": "all",
    "stylers": [
      {"saturation": 0},
      {"hue": "#e7ecf0"}
    ]
  },
  {
    "featureType": "road",
    "stylers": [
      {"saturation": -70}
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "water",
    "stylers": [
      {"visibility": "simplified"},
      {"saturation": -60}
    ]
  }
];

final mapStyle = jsonEncode(_mapStyle);
