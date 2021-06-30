class SunsetSunriseData{
  String sunrise;
  String sunset;

  //對從API取得的map中取日出和日落時間
  SunsetSunriseData(Map map) {
    sunrise = map['sunrise'];
    sunset = map['sunset'];
  }

  Map toJson() {
    var map = Map();
    map['sunrise'] = sunrise;
    map['sunset'] = sunset;
    return map;
  }
}