import 'package:analog_clock/services/location.dart';
import 'package:analog_clock/services/network.dart';

class Weather {
  // your openweathermap api key
  static const String _apiKey = '';
  static const String _openWeather = 'https://api.openweathermap.org/data/2.5/weather';

  Future getLocationWeather() async {
    Location location = await Location().getLocation();

    return await Network().getData('$_openWeather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$_apiKey');
  }
}
