
class Utils{
  static String makeTwoDigit(int number){
    return number.toString().padLeft(2,"0");
  }

  static int getFormatTime(DateTime time){
    return int.parse("${time.year}${makeTwoDigit(time.month)}${makeTwoDigit(time.day)}");
  }
  
  static DateTime stringToDateTime(String date){
    int year = int.parse(date.substring(0,4));
    int month = int.parse(date.substring(4,6));
    int day = int.parse(date.substring(6,8));

    return DateTime(year, month, day);
  }
}