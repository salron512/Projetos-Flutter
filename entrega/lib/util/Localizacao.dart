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
    //Position testePosition =
    // ignore: missing_required_param
    //  Position(latitude: -15.678107839468899, longitude: -58.09578097051735);
    // -15.678107839468899, -58.09578097051735

    List<Placemark> listaendereco =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var endereco = listaendereco[0];
    String cidade = endereco.subAdministrativeArea;
    print("cidade recuperada " + cidade);
    return cidade;
  }
}
