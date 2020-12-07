import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class Bichos extends StatefulWidget {
  @override
  _BichosState createState() => _BichosState();
}

class _BichosState extends State<Bichos> {

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache player = AudioCache(prefix: 'assets/audios/');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.loadAll([
      "cao.mp3", "gato.mp3", "leao.mp3", "macaco.mp3", "ovelha.mp3", "vaca.mp3",
    ]);
  }

  @override
  Widget build(BuildContext context) {

    //double  largura = MediaQuery.of(context).size.width;
    //double  altura = MediaQuery.of(context).size.height;

    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      childAspectRatio: MediaQuery.of(context).size.aspectRatio * 2,
      children:<Widget> [
        GestureDetector(
          onTap: () async{
          audioPlayer = await player.play("cao.mp3");
          },
          child: Image.asset("assets/imagens/cao.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("gato.mp3");
          },
          child: Image.asset("assets/imagens/gato.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("leao.mp3");
          },
          child: Image.asset("assets/imagens/leao.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("macaco.mp3");
          },
          child: Image.asset("assets/imagens/macaco.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("ovelha.mp3");
          },
          child: Image.asset("assets/imagens/ovelha.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("vaca.mp3");
          },
          child: Image.asset("assets/imagens/vaca.png"),
        ),
      ],
    );
  }
}
