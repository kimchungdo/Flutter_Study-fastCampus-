import 'dart:math' as math;


List<String> mealTime = ["아침", "점심", "저녁", "간식"];
List<String> mealType = ["균형잡힌", "단백질", "탄수화물", "지방", "치팅"];
List<String> wIntense = ["약하게", "적당히", "고강도"];
List<String> wPart = ["이두", "삼두", "등", "가슴", "어깨", "하체"];



class Utils {

  static int getFormatTime(DateTime date){              //포멧 변경 함수(int로)
    return int.parse("${date.year}${makeTwoDigit(date.month)}${makeTwoDigit(date.day)}");
  }
  
  static DateTime numToDateTime(int date){         //dateTime 을 리턴해주는 타입
    String _d = date.toString();
    int year = int.parse(_d.substring(0,4));
    int month = int.parse(_d.substring(4,6));
    int day = int.parse(_d.substring(6,8));

    return DateTime(year, month, day);
  }

  static String makeTwoDigit(int num){           //두자릿수로 만들기 위한 함수
    return num.toString().padLeft(2, "0");
  }
  static DateTime stringToDateTime(String date){
    int year = int.parse(date.substring(0,4));
    int month = int.parse(date.substring(4,6));
    int day = int.parse(date.substring(6,8));

    return DateTime(year, month, day);
  }
}