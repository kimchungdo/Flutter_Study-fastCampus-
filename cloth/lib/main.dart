import 'package:cloth/data/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/weather.dart';

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
  List<String> sky = ["assets/img/sky1.png", "assets/img/sky2.png", "assets/img/sky3.png", "assets/img/sky4.png"];
  List<String> status = ["날이 아주 좋아요!", "산책하기 좋곘어요", "오늘은 흐리네요", "우산 꼭 챙기세요"];
  List<Color> color = [
    Color(0xFFf78144),
    Color(0xFF1d9fea),
    Color(0xFF523de4),
    Color(0xFF587d9a)
  ];
  int level = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color[level],
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 50),
            Text("구로구", textAlign: TextAlign.center,
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
                Text("26℃", style: TextStyle(
                color: Colors.white,
                fontSize: 28
            ),),
                Column(
                  children: [
                    Text("7월 16일", style: TextStyle(
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
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  10,
                    (idx){
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("온도", style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),),
                          Text("강수확률", style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),),
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/img/sky1.png"),
                            alignment: Alignment.centerRight,
                          ),
                          Text("0800", style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),),
                        ],
                      )
                    );
                    }
                ),
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          final api = WeatherApi();
          List<Weather> weather = await api.getWeather(1, 1, 20211116, "0800");
          for(final w in weather){
            print(w.date);
            print(w.tmp);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
