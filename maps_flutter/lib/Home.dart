import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Set<Marker> _marcadadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polyline = {};

  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController googleController) {
    _controller.complete(googleController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(-15.579162, -57.913824),
            zoom: 18,
            tilt: 0,
            bearing: 0)));
  }
  /*

  _carregarMarcadores() {
    Set<Marker> _marcadadoresLocal = {};

    Marker marcadorInicial = Marker(
      markerId: MarkerId("marcador-inicial"),
      position: LatLng(-15.579162, -57.913824),
      infoWindow: InfoWindow(title: "sitio"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      onTap: () {
        print("sitio clicado");
      },
      //rotation: 45
    );

    Marker marcadorLagoa = Marker(
        markerId: MarkerId("marcador-lagoa"),
        position: LatLng(-15.579841, -57.914346),
        infoWindow: InfoWindow(title: "lagoa"));

    _marcadadoresLocal.add(marcadorInicial);
    _marcadadoresLocal.add(marcadorLagoa);

    setState(() {
      _marcadadores = _marcadadoresLocal;
    });
    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygo1"),
        fillColor: Colors.transparent,
        strokeColor: Colors.red,
        strokeWidth: 5,
        points: [
          LatLng(-15.580051, -57.914562),
          LatLng(-15.580060, -57.914791),
          LatLng(-15.580463, -57.914732),
          LatLng(-15.580398, -57.914498),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("clicando na área");
        },
        zIndex: 0);
    listaPolygons.add(polygon1);

    setState(() {
      _polygons = listaPolygons;
    });

    Set<Polygon> listaPolygon2 = {};
    Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygo2"),
        fillColor: Colors.purple,
        strokeColor: Colors.orange,
        strokeWidth: 2,
        points: [
          LatLng(-15.580222, -57.914420),
          LatLng(-15.580269, -57.914838),
          LatLng(-15.580473, -57.914583),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("clicando na área");
        },
        zIndex: 1);
    listaPolygons.add(polygon2);

    setState(() {
      _polygons = listaPolygon2;
    });

    Set<Polyline> listaPolylines = {};

    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline"),
        color: Colors.red,
        width: 10,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.bevel,
        points: [
          LatLng(-15.580051, -57.914562),
          LatLng(-15.580060, -57.914791),
          LatLng(-15.580463, -57.914732),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("clicando na polyline");
        });
    listaPolylines.add(polyline);

    setState(() {
      _polyline = listaPolylines;
    });
  }
  */

  _recuperaLocalizacaoUSuario() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print("Minha localização" + position.toString());
  }

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    _recuperaLocalizacaoUSuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.done,
        ),
        onPressed: _movimentarCamera,
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
              target: LatLng(-15.580060, -57.914791),
              zoom: 17,
              tilt: 0,
              bearing: 30),
          onMapCreated: _onMapCreated,
          markers: _marcadadores,
          polygons: _polygons,
          polylines: _polyline,
        ),
      ),
    );
  }
}
