import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Model/Video.dart';

const CHAVE_YOUTUBE_API = "AIzaSyDbtI72_C-sqm239drW4l2mXCA_AUTItDA";
//const ID_CANAL = "UCH0J9w484qySA_s-YYKq6Lg"; /* japa */
const ID_CANAL = "UCuVIWETFdxzwlHEHMbhm2_w";
const URL_BASE ="https://www.googleapis.com/youtube/v3/";

class Api {

  Future<List<Video>> pesquisar(String pesquisa) async {
    http.Response response = await http.get(
        URL_BASE + "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=50"
            "&order=date"
            "&key=$CHAVE_YOUTUBE_API"
           // "&channelId=$ID_CANAL"
            "&q=$pesquisa"
    );

    if( response.statusCode == 200 ){


      Map<String, dynamic> dadosJson = json.decode( response.body );

      List<Video> videos = dadosJson["items"].map<Video>(
              (map){
            return Video.fromJson(map);
            //return Video.converterJson(map);
          }
      ).toList();
      return videos;

      //print("Resultado: " + videos.toString() );

      /*
      for( var video in dadosJson["items"] ){
        print("Resultado: " + video.toString() );
      }*/
      //print("resultado: " + dadosJson["items"].toString() );

    }else{
    }
  }
}