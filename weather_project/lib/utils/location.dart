import 'package:location/location.dart';

class LocationHelper {
  double ?latitude;
  double ?longitude;


  Future<void> getCurrentLocation() async{
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    //location request control
    _serviceEnabled = await location.serviceEnabled(); //konum özelliği açık mı değilse
    if(!_serviceEnabled){ // false sonuç gelir
      _serviceEnabled = await location.requestService(); //Servis isteği gönderilir
      if(!_serviceEnabled){
        return;
      }
    }

    // user permission control
    _permissionGranted = await location.hasPermission(); // açılan panelde kullanıcı konum özelliğinin açılmasına izin vermiş mi?
    if(_permissionGranted == PermissionStatus.denied){ // izin verilmemişse
      _permissionGranted = await location.requestPermission(); // tekrar izin istenilir
      if(_permissionGranted == PermissionStatus.granted){
        return;
      }
    }

  // permission is okey
    _locationData = await location.getLocation(); // lokasyon sorguları yapılmış ve izinler alınmışsa kullanıcının latitude ve longitude bilgileri alınır.
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;


  }
}