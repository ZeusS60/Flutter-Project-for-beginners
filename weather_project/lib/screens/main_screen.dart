import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_project/utils/weather.dart';

class MainScreen extends StatefulWidget{
  final WeatherData weatherData;

  const MainScreen({super.key, required this.weatherData});

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }

}

class _MainScreenState extends State<MainScreen>{
  int ?temperature;
  Icon ?weatherDisplayIcon;
  AssetImage ?backgroundImage;
  String ?city;
  String ?country;

  void updateDisplayINfo(WeatherData weatherData){
    setState(() {
      temperature = weatherData.currentTemperature?.round();
      WeatherDisplayData weatherDisplayData = weatherData.getWeatherDisplayData();
      backgroundImage = weatherDisplayData.weatherImage;
      weatherDisplayIcon = weatherDisplayData.weatherIcon;
      city = weatherData.city;
      country = weatherData.country;
    });



  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateDisplayINfo(widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage!,
            fit: BoxFit.cover
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60,),
            Container(
              child: weatherDisplayIcon,
            ),
            SizedBox(height: 12,),
            Center(child: Text("$country°",style: TextStyle(
                fontSize: 50.0,
                letterSpacing: -6
            ),),),
            SizedBox(height: 12,),
            Center(child: Text("${temperature! - 273}°",style: TextStyle(
              fontSize: 50.0,
              letterSpacing: -6
            ),),),
            Center(child: Text("$city°",style: TextStyle(
                fontSize: 35.0,
                letterSpacing: -6
            ),),),
          ],
        ),
      ),
    );
  }
}