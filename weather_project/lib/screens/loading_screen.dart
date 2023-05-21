import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_project/screens/main_screen.dart';
import 'package:weather_project/utils/location.dart';
import 'package:weather_project/utils/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State {
  LocationHelper locationData = LocationHelper();

  Future<void> getLocationData() async {
    await locationData.getCurrentLocation();
  if(locationData.latitude == null || locationData.longitude == null){
    print("Konum bilgileri gelmiyor");

  }else{
    print("latitude:${locationData.latitude}");
    print("longitude:${locationData.longitude}");

  }
}

Future<void> getWeatherData() async {
    await getLocationData();
    WeatherData weatherData =WeatherData(locationData: locationData);
    await weatherData.getCurrentTemperature();
    
    if(weatherData.currentTemperature == null || weatherData.currentCondition == null){
      print("API den sıcaklık veya durum bilgisi boş dönüyor");
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return MainScreen(weatherData: weatherData,);
    }));
}
@override
  void initState() {
    super.initState();

   getWeatherData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Colors.deepPurpleAccent,Colors.black12])
        ),
        child:   Center(
          child:  SpinKitCubeGrid(
            color: Colors.deepPurple,
            size:  55.0,
            duration: Duration(milliseconds: 1600),
          ),
        ),
      ),
    );
  }
}
