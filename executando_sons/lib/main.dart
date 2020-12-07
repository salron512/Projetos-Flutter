import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache(prefix: "assets/audios/");
  bool primeiraExecucao = true;
  double volume = 0.5;

  _executar() async {

    audioPlayer.setVolume(volume);
   if(primeiraExecucao){
     audioPlayer = await audioCache.play("musica.mp3");
     primeiraExecucao = false;
   }else{
     audioPlayer.resume();
   }

    /*
    String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3";
    int resultado = await audioPlayer.play(url);

    if( resultado == 1 ){
      //sucesso
    }*/

  }

  _pausar() async{

    int resultado = await audioPlayer.pause();

  }
  _parar()async{
    int resultado = await audioPlayer.stop();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player Musicas"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children:<Widget> [
            Slider(
              value: volume ,
              min: 0,
              max: 1,
              //divisions: 10,
              onChanged:(novoVolume){
                setState(() {
                  volume = novoVolume;
                });
                audioPlayer.setVolume(novoVolume);
              } ,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget> [
                GestureDetector(
                  child: Image.asset("assets/imagens/executar.png") ,
                  onTap: (){_executar();},
                ),
                GestureDetector(
                  child: Image.asset("assets/imagens/pausar.png") ,
                  onTap: (){_pausar();},
                ),
                GestureDetector(
                  child: Image.asset("assets/imagens/parar.png") ,
                  onTap: (){_parar();},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
