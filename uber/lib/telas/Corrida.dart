import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber/Model/Usuario.dart';
import 'dart:async';

import 'package:uber/util/StatusRequisicao.dart';
import 'package:uber/util/UsuarioFirebase.dart';

class Corrida extends StatefulWidget {
  String idRequisicao;
  Corrida(this.idRequisicao);

  @override
  _CorridaState createState() => _CorridaState();
}

class _CorridaState extends State<Corrida> {
  String _textoBotao = "Aceitar corrida";
  Color _corBotao = Color(0xff1ebbd8);
  Function _fucaoBotao;
  TextEditingController _controllerDestino =
      TextEditingController(text: "av. paulista, 807");
  List<String> itensMenu = ["Configurações", "Deslogar"];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-15.612925, -57.919240), zoom: 15);
  Set<Marker> _marcadores = {};
  Map<String, dynamic> _dadosRequisicao;
  Position _localMotorista;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _fucaoBotao = funcao;
    });
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _exibirMarcadorPassageiro(position);

      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15);

    //  _movimentarCamera(_posicaoCamera);
      setState(() {
        _localMotorista = position;
      });
    });
  }

  _recuperaUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);

        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15);

        _movimentarCamera(_posicaoCamera);
        _localMotorista = position;
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _recuperarUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15);
      //  _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _exibirMarcadorPassageiro(Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/motorista.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
          markerId: MarkerId("marcador-motorista"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: "Meu local"),
          icon: icone);

      setState(() {
        _marcadores.add(marcadorPassageiro);
      });
    });
  }

  _recuperarRequisicao() async {
    String idRequisicao = widget.idRequisicao;
    print("ID REQUISICAO" + idRequisicao);
    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection("requisicoes").document(idRequisicao).get();
    _dadosRequisicao = documentSnapshot.data;

    _adicionarListenerRequisicao();
  }

  _adicionarListenerRequisicao() async {
    Firestore db = Firestore.instance;
    String idRequisicao = _dadosRequisicao["id"];
    await db
        .collection("requisicoes")
        .document(idRequisicao)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data != null) {
        Map<String, dynamic> dados = snapshot.data;
        String status = dados["status"];

        switch (status) {
          case StatusRequisicao.AGUARDANDO:
            _statusAguardando();
            break;
          case StatusRequisicao.A_CAMINHO:
            _statusAcaminho();
            break;
          case StatusRequisicao.VIAGEM:
            break;
          case StatusRequisicao.FINALIZADA:
            break;
        }
      }
    });
  }

  _statusAcaminho() {
    _alterarBotaoPrincipal("A caminho do passageiro", Colors.grey, null);
    double latitudePassageiro = _dadosRequisicao["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao["motorista"]["longitude"];
    _exibirDoisMarcadores(LatLng(latitudeMotorista, longitudeMotorista),
        LatLng(latitudePassageiro, longitudePassageiro));
    var nLat, nLon, sLat, sLon;
    if(latitudeMotorista <= latitudePassageiro){
      sLat = latitudeMotorista;
      nLat = latitudePassageiro;
    }else{
      sLat = latitudePassageiro;
      nLat = latitudeMotorista;
    }
    if(longitudeMotorista <= longitudePassageiro){
      sLon = longitudeMotorista;
      nLon = longitudePassageiro;
    }else{
      sLon = longitudePassageiro;
      nLon = longitudeMotorista;
    }

    _movimentarCameraBounds(LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    ));
  }

  _movimentarCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _statusAguardando() {
    _alterarBotaoPrincipal("Aceitar Corrida", Color(0xff1ebbd8), () {
      _aceitarCorrida();
    });
  }

  _exibirDoisMarcadores(LatLng latLng1, LatLng latLng2) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    Set<Marker> _listaMarcadores = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/motorista.png")
        .then((BitmapDescriptor icone) {
      Marker marcador1 = Marker(
          markerId: MarkerId("marcador-motorista"),
          position: LatLng(latLng1.latitude, latLng1.longitude),
          infoWindow: InfoWindow(title: "Motorista"),
          icon: icone);
      _listaMarcadores.add(marcador1);
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/passageiro.png")
        .then((BitmapDescriptor icone) {
      Marker marcador2 = Marker(
          markerId: MarkerId("marcador-passageiro"),
          position: LatLng(latLng2.latitude, latLng2.longitude),
          infoWindow: InfoWindow(title: "Passageiro"),
          icon: icone);
      _listaMarcadores.add(marcador2);
    });
    setState(() {
      _marcadores = _listaMarcadores;
    });
  }

  _aceitarCorrida() async {
    Usuario motorista = await UsuarioFirebase.getDadosUsuarioLogado();
    motorista.latitude = _localMotorista.latitude;
    motorista.longitude = _localMotorista.longitude;
    Firestore db = Firestore.instance;
    String idRequisicao = _dadosRequisicao["id"];

    await db.collection("requisicoes").document(idRequisicao).updateData({
      "motorista": motorista.toMap(),
      "status": StatusRequisicao.A_CAMINHO,
    }).then((_) async {
      String idPassageiro = _dadosRequisicao["passageiro"]["idUsuario"];
       await db.collection("requisicao_ativa").document(idPassageiro).updateData({
        "status": StatusRequisicao.A_CAMINHO,
      });
      String idMotorista = motorista.idUsuario;
      db
          .collection("requisicao_ativa_motorista")
          .document(idMotorista)
          .setData({
        "id_requisicao": idRequisicao,
        "id_usuario": idMotorista,
        "status": StatusRequisicao.A_CAMINHO,
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
    _recuperarRequisicao();
    _recuperaUltimaLocalizacaoConhecida();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel Corrida"),
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              // myLocationEnabled: false,
              markers: _marcadores,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: Platform.isIOS
                      ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                      : EdgeInsets.all(10),
                  child: RaisedButton(
                      child: Text(
                        _textoBotao,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      color: _corBotao,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: _fucaoBotao),
                )),
          ],
        ),
      ),
    );
  }
}
