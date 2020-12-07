import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home() ,
  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();


}
AudioPlayer audioPlayer = AudioPlayer();

_executar() async{
  String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3";
  int resultado = await audioPlayer.play(url);

}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

_executar();


    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(

      ),
    );
  }
}
