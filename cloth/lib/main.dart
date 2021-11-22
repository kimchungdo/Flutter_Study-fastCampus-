import 'package:cloth/cloth.dart';
import 'package:cloth/data/api.dart';
import 'package:cloth/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/preference.dart';
import 'data/weather.dart';
import 'location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> clothes = ["assets/img/shirts.png", "assets/img/short.png", "assets/img/pants.png" ];
  List<Weather> weather = [];
  List<ClothTmp> tmpCloth = [];
  Weather current;
  LocationData location = LocationData(lat: 37.498122, lng: 127.027565, name: "강남구", x: 0, y: 0);
  List<String> sky = ["assets/img/sky1.png", "assets/img/sky2.png", "assets/img/sky3.png", "assets/img/sky4.png"];
  List<String> status = ["날이 아주 좋아요!", "산책하기 좋곘어요", "오늘은 흐리네요", "우산 꼭 챙기세요"];
  List<Color> color = [
    Color(0xFFf78144),
    Color(0xFF1d9fea),
    Color(0xFF523de4),
    Color(0xFF587d9a)
  ];
  int level = 0;

  void getWeather() async {

    final api = WeatherApi();
    final now = DateTime.now();
    Map<String, int> xy = Utils.latLngToXY(location.lat, location.lng);

    final pref = Preference();
    tmpCloth = await pref.getTmp();

    int time2 = int.parse("${now.hour}10");
    String _time = "";
    if(time2 > 2300){
      _time = "2300";
    }else if(time2 > 2000){
      _time = "2000";
    }
    else if(time2 > 1700){
      _time = "1700";
    }
    else if(time2 > 1400){
      _time = "1400";
    }
    else if(time2 > 1100){
      _time = "1100";
    }else if(time2 > 800){
      _time = "0800";
    }else if(time2 > 500){
      _time = "0500";
    }
    else{
      _time = "0200";
    }

    weather = await api.getWeather(xy["nx"], xy["ny"], Utils.getFormatTime(DateTime.now()), _time);

    int time = int.parse("${now.hour}00");
    weather.removeWhere((w) => w.time < time);
    current = weather.first;


    clothes = tmpCloth.firstWhere((t) => t.tmp < current.tmp).cloth;
    level = getLevel(current);
    setState((){});
  }

  int getLevel(Weather w){
    if(w.sky > 8){
      return 3;
    }
    else if (w.sky> 5){
      return 2;
    }
    else if (w.sky>2){
      return 1;
    }
    return 0;
  }

  @override
  void initState(){
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx)=>ClothPage())
            );
            getWeather();
          }, icon: Icon(Icons.category))
        ]
      ),
      backgroundColor: color[level],
      body: weather.isEmpty ? Container(child: Text("날씨 정보를 불러오고 있어요")) : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 50),
            Text("${location.name}", textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                fontSize: 20
              ),),
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Image.asset(sky[level]),
              alignment: Alignment.centerRight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("${current.tmp}℃", style: TextStyle(
                color: Colors.white,
                fontSize: 28
            ),),
                Column(
                  children: [
                    Text("${Utils.stringToDateTime(current.date).month}월 ${Utils.stringToDateTime(current.date).day}일", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),),
                    Text(status[level], style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),),
                  ],
                )
              ],
            ),
            Container(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text("오늘 어울리는 복장을 추천해드려요", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),),
            ),
            Container(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(clothes.length, (idx){
                return Container(
                  padding: EdgeInsets.all(8),
                  width: 100,
                  height: 100,
                  child: Image.asset(clothes[idx], fit: BoxFit.contain),
                );
              }),
            ),
            Container(height: 30),
            Expanded(
              child: Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    weather.length,
                      (idx){
                      final w = weather[idx];
                      int _level = getLevel(w);
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${w.tmp}℃", style: TextStyle(
                                color: Colors.white,
                                fontSize: 10
                            ),),
                            Text("${w.pop}%", style: TextStyle(
                                color: Colors.white,
                                fontSize: 10
                            ),),
                            Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(sky[_level]),
                              alignment: Alignment.centerRight,
                            ),
                            Text("${w.time}", style: TextStyle(
                                color: Colors.white,
                                fontSize: 10
                            ),),
                          ],
                        )
                      );
                      }
                  ),
                ),
              ),
            ),
            Container(height: 50),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          LocationData data = await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => LocationPage())
          );

          if(data != null){
            location = data;
            getWeather();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
