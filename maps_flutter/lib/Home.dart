import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraPosition  _posicaoCamera ;
  Set<Marker> _marcadadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polyline = {};
  Position _positionUsuario;

  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController googleController) {
    _controller.complete(googleController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;

    googleMapController.animateCamera(CameraUpdate.newCameraPosition
      (_posicaoCamera));
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


  _recuperaLocalizacaoUSuario() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print("Minha localização" + position.toString());
    setState(() {
    _posicaoCamera = CameraPosition(target: LatLng(
        position.latitude, position.longitude),
      zoom: 17
    );
    });
  }
   */
  _adicionarListenerLocalizacao(){
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 2
    );

    geolocator.getPositionStream(locationOptions).listen((Position position) {

      Set<Marker> _marcadadoresLocal = {};

      Marker marcadorUsuario = Marker(
        markerId: MarkerId("marcador-inicial"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: "Usuario"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () {
          print("Usuario clicado");
        },
        //rotation: 45
      );
      setState(() {
        _marcadadores.add(marcadorUsuario);

        _posicaoCamera = CameraPosition(target: LatLng(
            position.latitude, position.longitude),
            zoom: 17
        );
      });
      _movimentarCamera();

    });

  }

  _recuperarLocalParaEndereco() async {

    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromAddress("Av. Paulista, 1372");

    print("total: " + listaEnderecos.length.toString() );

    if( listaEnderecos != null && listaEnderecos.length > 0 ){

      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado  = "\n administrativeArea " + endereco.administrativeArea ;
      resultado += "\n subAdministrativeArea " + endereco.subAdministrativeArea ;
      resultado += "\n locality " + endereco.locality ;
      resultado += "\n subLocality " + endereco.subLocality ;
      resultado += "\n thoroughfare " + endereco.thoroughfare ;
      resultado += "\n subThoroughfare " + endereco.subThoroughfare ;
      resultado += "\n postalCode " + endereco.postalCode ;
      resultado += "\n country " + endereco.country ;
      resultado += "\n isoCountryCode " + endereco.isoCountryCode ;
      resultado += "\n position " + endereco.position.toString() ;

      print("resultado: " + resultado );
      //-23.565564, -46.652753

    }

  }

  _recuperarLocalParaEnderecoLT() async {

    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromCoordinates(-23.565564, -46.652753);

    print("total: " + listaEnderecos.length.toString() );

    if( listaEnderecos != null && listaEnderecos.length > 0 ){

      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado  = "\n administrativeArea " + endereco.administrativeArea ;
      resultado += "\n subAdministrativeArea " + endereco.subAdministrativeArea ;
      resultado += "\n locality " + endereco.locality ;
      resultado += "\n subLocality " + endereco.subLocality ;
      resultado += "\n thoroughfare " + endereco.thoroughfare ;
      resultado += "\n subThoroughfare " + endereco.subThoroughfare ;
      resultado += "\n postalCode " + endereco.postalCode ;
      resultado += "\n country " + endereco.country ;
      resultado += "\n isoCountryCode " + endereco.isoCountryCode ;
      resultado += "\n position " + endereco.position.toString() ;

      print("resultado: " + resultado );
      //-23.565564, -46.652753

    }

  }


  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    //_recuperaLocalizacaoUSuario();
     _adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    _recuperarLocalParaEnderecoLT();
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
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
         myLocationEnabled: true,
          markers: _marcadadores,
          //polygons: _polygons,
          //polylines: _polyline,
        ),
      ),
    );
  }
}
