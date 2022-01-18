import 'package:geolocator/geolocator.dart';

class MyLocation {
  double Latit = 0.0;
  double Longit = 0.0;

  Future<void> getMyCurrentLocation() async {
    try {
      Position myPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      Latit = myPos.latitude;
      Longit = myPos.longitude;
      print(Latit);
      print(Longit);
    } catch (err) {
      print('err: err from loading currentLocation');
      print(err);
    }
  }

  setLocation(double latit, double longit) {
    this.Latit = latit;
    this.Longit = longit;
  }
}
