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
    Position testePosition =
       Position(latitude: -14.44883053081522, longitude: -56.846409733671116);
    //  -14.448830530815224, -56.846409733671116

    var listaendereco =
        await placemarkFromCoordinates(testePosition.latitude, testePosition.longitude);
    var endereco = listaendereco[0];
    String cidade = endereco.subAdministrativeArea;
    print("cidade recuperada "+ cidade);
    return cidade;
  }
}
