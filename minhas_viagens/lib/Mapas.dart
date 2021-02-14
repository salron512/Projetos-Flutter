import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapas extends StatefulWidget {
  @override
  _MapasState createState() => _MapasState();
}

class _MapasState extends State<Mapas> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _exibirMaracador(LatLng latLng) {
    Marker marcador = Marker(
        markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
      position: latLng,
      infoWindow: InfoWindow(
        title: "Marcador"
      )
    );
    setState(() {
      _marcadores.add(marcador);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mapa"),
        ),
        body: Container(
          child: GoogleMap(
            markers: _marcadores,
            initialCameraPosition: CameraPosition(
                target: LatLng(-23.562436, -46.655005), zoom: 18),
            onMapCreated: _onMapCreated,
            mapType: MapType.hybrid,
            onLongPress: _exibirMaracador,
          ),
        ));
  }
}
