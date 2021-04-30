import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  String idDocumento;
  Mapa(this.idDocumento);
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-15.679356, -58.095522), zoom: 18);
  FirebaseFirestore _db = FirebaseFirestore.instance;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarMaracador() async {
    LatLng latLng;
    double latitude;
    double longitude;
    String idDocumento = widget.idDocumento;
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> dados;
    var snap =
        db.collection("localizacaoEntregador").doc(idDocumento).snapshots();
    snap.listen((event) {
      latitude = dados["latitude"];
      longitude = dados["longitude"];
      Marker marcador = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: dados["nomeEntregador"]));
      setState(() {
        _marcadores.add(marcador);
        _posicaoCamera =
            CameraPosition(target: LatLng(latitude, longitude), zoom: 18);
      });
      // _movimentarCamera();
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarMaracador();
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
            initialCameraPosition: _posicaoCamera,
            onMapCreated: _onMapCreated,
            mapType: MapType.hybrid,
            //myLocationEnabled: true,
          ),
        ));
  }
}
