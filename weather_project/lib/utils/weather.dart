
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:weather_project/utils/location.dart';

const apiKey = "0874864cde328e6c1bdbd53277e5eee9";

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;
  WeatherDisplayData({required this.weatherIcon,required this.weatherImage});
}


class WeatherData{
  LocationHelper locationData;
  double ?currentTemperature;
  int ?currentCondition;
  String ?city;
  String ?country;


  WeatherData({required this.locationData});

  Future<void> getCurrentTemperature() async{
    Response response = await get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&unit=metric'));

    if(response.statusCode == 200){
      String data = response.body;

      var currentWeather = jsonDecode(data);
      try{
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        city = currentWeather['name'];
        country = currentWeather['sys']['country'];
      }
      catch(e){
        print(e);
      }
    }else{
      print("API den değer gelmiyor");
    }

  }

  WeatherDisplayData getWeatherDisplayData(){
    if(currentCondition! < 600){
      return WeatherDisplayData(weatherIcon: Icon(
        FontAwesomeIcons.cloud,
        size: 55.0,
        
      ), weatherImage: AssetImage('assets/bulutlu.png'));
    }
    else{
      var now = DateTime.now();
      if(now.hour >=19){
        return WeatherDisplayData(weatherIcon: Icon(
          FontAwesomeIcons.moon,
          size: 55.0,

        ), weatherImage: AssetImage('assets/gece.png'));
      }else{
        return WeatherDisplayData(weatherIcon: Icon(
          FontAwesomeIcons.sun,
          size: 55.0,

        ), weatherImage: AssetImage('assets/sun.png'));
      }
    }
  }
}