import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  Position _position;
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-15.679356, -58.095522), zoom: 18);

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarMaracador() async {
    LatLng latLng;
    double latitude = 0;
    double longitude = 0;
    String idDocumento = widget.idDocumento;
    Map<String, dynamic> dados;

    Stream<DocumentSnapshot> query = FirebaseFirestore.instance
        .collection("localizacaoEntregador")
        .doc(idDocumento)
        .snapshots();
    query.listen((event) {
      dados = event.data();
      latitude = dados["latitude"];
      longitude = dados["longitude"];
      latLng = LatLng(latitude, longitude);
      print("latitude" + dados["latitude"].toString());
      Marker marcador = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: dados["nomeEntregador"]));
      setState(() {
        _marcadores.add(marcador);
        _posicaoCamera =
            CameraPosition(target: LatLng(latitude, longitude), zoom: 18);
      });
      _movimentarCamera();
    });
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _localizacaoInicial() async {
    double latitude = _position.altitude;
    double longitude = _position.longitude;
    setState(() async {
      _position = await Geolocator.getCurrentPosition();
      _posicaoCamera =
          CameraPosition(target: LatLng(latitude, longitude), zoom: 18);
    });
  }

  @override
  void initState() {
    super.initState();
    _localizacaoInicial();
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
            myLocationEnabled: true,
          ),
        ));
  }
}
