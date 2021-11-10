

class Mise {
  int pm10;
  int pm25;
  int khai;
  String dateTime;
  double so;
  double co;
  double no;
  double o3;

  Mise({this.pm10, this.pm25, this.khai, this.dateTime,this.co, this.no, this.o3, this.so});

  factory Mise.fromJson(Map<String, dynamic> data){
    return Mise(
      pm10: int.tryParse(data["pm10Value"] ?? "") ?? 0,
      pm25: int.tryParse(data["pm25Value"] ?? "") ?? 0,
      khai: int.tryParse(data["khaiGrade"] ?? "") ?? 0,
      dateTime: data["dateTime"] ?? "",
    );
  }
}