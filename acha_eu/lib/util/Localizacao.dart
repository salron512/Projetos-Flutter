import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Localizacao {
  static verificaLocalizacao() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.checkPermission();
        return Future.error('Location permissions are denied');
      }
    }
  }

  static recuperaLocalizacao() async {
    Position position = await Geolocator.getCurrentPosition();
   // Position testePosition =
      //  Position(latitude:  -14.399540373231916, longitude: -56.425837050175566);
    //  -14.399540373231916, -56.425837050175566

    var listaendereco =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var endereco = listaendereco[0];
    String cidade = endereco.subAdministrativeArea;
    print("cidade recuperada "+ cidade);
    return cidade;
  }
}
