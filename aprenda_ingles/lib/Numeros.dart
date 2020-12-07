import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Numeros extends StatefulWidget {
  @override
  _NumerosState createState() => _NumerosState();
}

class _NumerosState extends State<Numeros> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache player = AudioCache(prefix: 'assets/audios/');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.loadAll([
      "1.mp3", "2.mp3", "3.mp3", "4.mp3", "5.mp3", "6.mp3",
    ]);
  }
  @override
  Widget build(BuildContext context) {

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: MediaQuery.of(context).size.aspectRatio * 2,
      scrollDirection: Axis.vertical,
      children:<Widget> [
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("1.mp3");
          },
          child: Image.asset("assets/imagens/1.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("2.mp3");
          },
          child: Image.asset("assets/imagens/2.png"),
        ),
        GestureDetector(
          onTap: () async{

             await player.play("3.mp3");
          },
          child: Image.asset("assets/imagens/3.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("4.mp3");
          },
          child: Image.asset("assets/imagens/4.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("5.mp3");
          },
          child: Image.asset("assets/imagens/5.png"),
        ),
        GestureDetector(
          onTap: () async{
            audioPlayer = await player.play("6.mp3");
          },
          child: Image.asset("assets/imagens/6.png"),
        ),
      ],
    );
  }
}
