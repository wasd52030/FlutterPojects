import 'sunset_sunrise_data.dart';

class SunsetSunriseDataResponse{
  SunsetSunriseData results;
  String status;

  SunsetSunriseDataResponse(Map map) {
    //將取得的資訊做分類
    results = SunsetSunriseData(map['results']);
    status = map['status'];
  }

  Map toJson() {
    var map = Map();
    //把SunsetSunriseData Class中的資料做成Map
    map['results'] = results.toJson();
    map['status'] = status;
    return map;
  }
}