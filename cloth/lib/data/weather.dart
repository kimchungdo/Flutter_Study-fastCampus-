

class Weather{
  String date;
  int time;
  int pop;
  int pty;
  String pcp;
  int sky;
  double wsd;
  int tmp;
  int reh;

  Weather({this.date, this.pcp, this.pop, this.pty, this.reh, this.sky, this.time, this.tmp, this.wsd});

  factory Weather.fromJson(Map<String, dynamic> data){

    return Weather(
      date: data["fcstDate"],
      time: int.tryParse(data["fcstTime"]?? "") ?? 0,
      pop: int.tryParse(data["POP"]?? "") ?? 0,
      pty: int.tryParse(data["PTY"]?? "") ?? 0,
      pcp: data["PCP"],
      sky: int.tryParse(data["SKY"]?? "") ?? 0,
      wsd: double.tryParse(data["WSD"]?? "") ?? 0,
      tmp: int.tryParse(data["TMP"]?? "") ?? 0,
      reh: int.tryParse(data["REH"]?? "") ?? 0,
    );
  }
}

class LocationData{
  String name;
  int x;
  int y;
  double lat;
  double lng;

  LocationData({this.lat, this.lng, this.name, this.x, this.y});
}