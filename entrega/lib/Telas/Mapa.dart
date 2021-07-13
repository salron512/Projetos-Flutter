import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class Mapa extends StatefulWidget {
  String idDocumento;
  Mapa(this.idDocumento);
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  Stream<DocumentSnapshot> _query;
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(0.0, 0.0), zoom: 18);

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarMaracador() {
    Marker marcador;
    double latitude = 0;
    double longitude = 0;
    String idDocumento = widget.idDocumento;
    Map<String, dynamic> dados;

    _query = FirebaseFirestore.instance
        .collection("localizacaoEntregador")
        .doc(idDocumento)
        .snapshots();
    _query.listen((event) {
      if (mounted) {
        dados = event.data();
        latitude = dados["latitude"];
        longitude = dados["longitude"];
        print("latitude" + dados["latitude"].toString());
        setState(() {
          _marcadores.clear();
          marcador = Marker(
              markerId: MarkerId("entregador"),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: "Entregador"));
          _marcadores.add(marcador);
          _posicaoCamera =
              CameraPosition(target: LatLng(latitude, longitude), zoom: 18);
        });
        _movimentarCamera();
      }
    });
  }

  _movimentarCamera() async {
    if (mounted) {
      GoogleMapController googleMapController = await _controller.future;
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
    }
  }

  @override
  void initState() {
    super.initState();
    _adicionarMaracador();
  }

  @override
  void dispose() {
    super.dispose();
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
            mapType: MapType.normal,
            myLocationEnabled: true,
          ),
        ));
  }
}
