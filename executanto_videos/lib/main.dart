import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("videos/exemplo.mp4")
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          // _controller.play();
        });
      });

    /*
   _controller = VideoPlayerController.network("https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"
    )..initialize().then((_){
      setState(() {
        _controller.play();
      });
   });
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Text("precione o play"),
      ),
      floatingActionButton: FloatingActionButton(
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
      ),
    );
  }
}
