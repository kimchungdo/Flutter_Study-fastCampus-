
import 'package:cloth/data/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  Future<List<ClothTmp>> getTmp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<String> tmp30 = pref.getStringList("30") ?? ["assets/img/shirts.png", "assets/img/short.png", "assets/img/pants.png" ];
    List<String> tmp20 = pref.getStringList("20") ?? ["assets/img/shirts.png", "assets/img/short.png", "assets/img/pants.png" ];
    List<String> tmp10 = pref.getStringList("10") ?? ["assets/img/shirts.png", "assets/img/short.png", "assets/img/pants.png" ];
    List<String> tmp0 = pref.getStringList("0") ?? ["assets/img/shirts.png", "assets/img/short.png", "assets/img/pants.png" ];

    return[
      ClothTmp(tmp: 30, cloth: tmp30),
      ClothTmp(tmp: 20, cloth: tmp20),
      ClothTmp(tmp: 10, cloth: tmp10),
      ClothTmp(tmp: 0, cloth: tmp0),
    ];
  }

  Future<void> setTmp(ClothTmp cloth) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setStringList("${cloth.tmp}", cloth.cloth);
  }
}