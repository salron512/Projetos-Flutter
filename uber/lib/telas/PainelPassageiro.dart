import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uber/Model/Requisicao.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:uber/Model/Destino.dart';
import 'package:uber/Model/Usuario.dart';
import 'package:uber/util/StatusRequisicao.dart';
import 'package:uber/util/UsuarioFirebase.dart';

class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  List<String> _escolha = ["Configuração", "Deslogar"];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-15.579259, -57.913787), zoom: 19);
  Set<Marker> _marcadores = {};
  TextEditingController _controllerDestino = TextEditingController();
  bool _exibirCaixaEnderecoDestino = true;
  String _textoBotao = "Chamar Uber";
  Color _corBotao = Color(0xff1ebbd8);
  Function _fucaoBotao;
  String _idRequisicao;

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configuração":
        break;
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _exibirMarcadorPassageiro(position);
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);
      _movimentarCamera(_posicaoCamera);
    });
  }

  _recuperarUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcadorPassageiro(Position position) async {
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuario = await auth.currentUser();
    if (usuario != null) {
      DocumentSnapshot snapshot =
          await db.collection("usuarios").document(usuario.uid).get();
      Map<String, dynamic> dados = snapshot.data;
      String nomeUsuario = dados["nome"];

      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: pixelRatio),
              "imagens/passageiro.png")
          .then((BitmapDescriptor icone) {
        Marker marcadorPassageiro = Marker(
          markerId: MarkerId(
            "marcador-passageiro",
          ),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: nomeUsuario),
          icon: icone,
        );
        setState(() {
          _marcadores.add(marcadorPassageiro);
        });
      });
    }
  }

  _salvarRequisicao(Destino destino) async {
    print("metodo chamado");

    Usuario passageiro = await UsuarioFirebase.getDadosUsuarioLogado();
    Requisicao requisicao = Requisicao();
    requisicao.destino = destino;
    requisicao.passageiro = passageiro;
    requisicao.status = StatusRequisicao.AGUARDANDO;

    Firestore db = Firestore.instance;
    await db.collection("requisicoes").document(requisicao.id)
        .setData(requisicao.toMap());

    Map<String, dynamic> dadosRequisicaoAtiva= {};
    dadosRequisicaoAtiva["id_requisiacao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = passageiro.idUsuario;
    dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

    db.collection("requisicao_ativa")
    .document(passageiro.idUsuario).setData(dadosRequisicaoAtiva);
  }

  _chamarUber() async {
    String enderecoDestino = _controllerDestino.text;
    if (enderecoDestino.isNotEmpty) {
      print("chamar Uber");
      List<Placemark> listaEndereco =
          await Geolocator().placemarkFromAddress(enderecoDestino);
      if (listaEndereco != null && listaEndereco.length > 0) {
        Placemark endereco = listaEndereco[0];
        Destino destino = Destino();
        destino.cidade = endereco.subAdministrativeArea;
        destino.cep = endereco.postalCode;
        destino.bairro = endereco.subLocality;
        destino.rua = endereco.thoroughfare;
        destino.numero = endereco.subThoroughfare;

        destino.latitude = endereco.position.latitude;
        destino.longetude = endereco.position.longitude;

        String enderecoConfirmacao;
        enderecoConfirmacao = "\n Cidade: " + destino.cidade;
        enderecoConfirmacao += "\n Rua: " + destino.rua;
        enderecoConfirmacao += "\n Bairro: " + destino.bairro;
        enderecoConfirmacao += "\n Cep: " + destino.cep;

        showDialog(
            context: context,
            // ignore: missing_return
            builder: (context) {
              return AlertDialog(
                title: Text("Confirmação do endereço"),
                content: Text(enderecoConfirmacao),
                contentPadding: EdgeInsets.all(16),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text("Cancelar", style: TextStyle(color: Colors.red)),
                  ),
                  FlatButton(
                    onPressed: () {
                      _salvarRequisicao(destino);
                      Navigator.pop(context);
                    },
                    child: Text("Confirmar",
                        style: TextStyle(color: Colors.green)),
                  )
                ],
              );
            });
      }
    }
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao){
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _fucaoBotao = funcao;
    });
  }


  _statusNaoChamado(){
    _exibirCaixaEnderecoDestino= true;

    _alterarBotaoPrincipal(
        "Chamar Uber",
        Color(0xff1ebbd8),
        (){
          _chamarUber();
        }
    );
  }

  _statusAguardando(){
    _exibirCaixaEnderecoDestino= false;
    _alterarBotaoPrincipal(
        "Cancelar",
        Colors.red,
            (){
          _cancelarUber();
        }
    );

  }
  _cancelarUber() async{
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    Firestore db = Firestore.instance;

    Map<String, dynamic> status ={
      "status": StatusRequisicao.CANCELADA
    };
    await db.collection("requisicoes")
        .document(_idRequisicao).updateData(status).then((_){
       db.collection("requisicao_ativa")
          .document(firebaseUser.uid).delete();
    });
    
  }

  _adicionarListenerLocalizacaoAtiva() async{
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    Firestore db = Firestore.instance;
    await db.collection("requisicao_ativa").document(firebaseUser.uid)
        .snapshots().listen((snapshot) {
          if(snapshot.data != null){
            Map<String, dynamic> dados = snapshot.data;
            String status = dados["status"];
             _idRequisicao = dados["id_requisiacao"];

            switch(status){
              case StatusRequisicao.AGUARDANDO:
                _statusAguardando();
                break;
              case StatusRequisicao.A_CAMINHO:
                break;
              case StatusRequisicao.VIAGEM:
                break;
              case StatusRequisicao.FINALIZADA:
                break;
            }

          }else{
            _statusNaoChamado();
          }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
    _adicionarListenerLocalizacaoAtiva();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel Passageiro"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            // ignore: missing_return
            itemBuilder: (context) {
              return _escolha.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
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
            Visibility(
              visible: _exibirCaixaEnderecoDestino,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 20),
                                width: 10,
                                height: 10,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                              ),
                              hintText: "Meu local",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 16)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: _controllerDestino,
                          // readOnly: true,
                          decoration: InputDecoration(
                              icon: Container(
                                margin: EdgeInsets.only(left: 20),
                                width: 10,
                                height: 10,
                                child: Icon(
                                  Icons.local_taxi,
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Digite o destino",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 16)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
