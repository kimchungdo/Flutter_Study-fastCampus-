import 'package:flutter/material.dart';

Color mainColor = Color(0xFF81D0D6);
Color bgColor = Colors.white;
Color ibgColor = Colors.grey.withOpacity(0.1);           //inactive(클릭되지 않은, 활성화 되지 않은)            //withOpacity: 투명도 추가하기
Color txtColor = Colors.black;
Color iTxtColor = Colors.black38;
double cardSize = 150;

MaterialColor mainMColor = MaterialColor(
mainColor.value,
<int, Color>{
50: mainColor,
100: mainColor,
200: mainColor,
300: mainColor,
400: mainColor,
500: mainColor,
600: mainColor,
700: mainColor,
800: mainColor,
900: mainColor,
},
);



TextStyle sTS = TextStyle(fontSize: 12);
TextStyle mTS = TextStyle(fontSize: 16);
TextStyle lTS = TextStyle(fontSize: 20);           //디자인을 통일 시키기 위함 4-5개 정도 이용하여 일괄적으로 이용하는 것이 좋음


void changeToDarkMode(){
  bgColor = Color(0xFF3a3a3c);
  txtColor = Colors.white;
}