import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mapas extends StatefulWidget {
  String IdViagem;

  Mapas({this.IdViagem});

  @override
  _MapasState createState() => _MapasState();
}

class _MapasState extends State<Mapas> {
  var _geolocator = Geolocator();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-15.679356, -58.095522), zoom: 18);
  Firestore _db = Firestore.instance;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarMaracador(LatLng latLng) async {
    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Placemark endereco = listaEnderecos[0];
      String rua = endereco.thoroughfare;

      Marker marcador = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: latLng,
          infoWindow: InfoWindow(title: rua));
      setState(() {
        _marcadores.add(marcador);
        Map<String, dynamic> viagens = Map();
        viagens["titulo"] = rua;
        viagens["latitude"] = latLng.latitude;
        viagens["longitude"] = latLng.longitude;
        _db.collection("viagens").add(viagens);
      });
    }
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 2);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 18);
        _movimentarCamera();
      });
    });
  }

  _recuperaViagemPeloID(String id) async {
    if (id != null) {
      print("ID: " + id);

      DocumentSnapshot documentSnapshot =
          await _db.collection("viagens").document(id).get();
      var dados = documentSnapshot.data;
      String titulo = dados["titulo"];
      LatLng latLng = LatLng(dados["latitude"], dados["longitude"]);

      Marker marcador = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: latLng,
          infoWindow: InfoWindow(title: titulo));
      setState(() {
        _marcadores.add(marcador);
        _posicaoCamera = CameraPosition(target: latLng, zoom: 18);
      });
      _movimentarCamera();
    } else {
      print("Erro!!!!!!!!!!!");
      _adicionarListenerLocalizacao();
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperaViagemPeloID(widget.IdViagem);
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
            onLongPress: _adicionarMaracador,
            //myLocationEnabled: true,
          ),
        ));
  }
}
