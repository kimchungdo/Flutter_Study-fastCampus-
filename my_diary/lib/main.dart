import 'package:flutter/material.dart';
import 'package:my_diary/write.dart';

import 'data/database.dart';
import 'data/diary.dart';
import 'data/util.dart';

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

  int selectIndex = 0;
  final dbHelper = DatabaseHelper.instance;
  Diary todayDiary;

  List<String> statusImg = [
    "assets/img/ico-weathe-02-r.png",
    "assets/img/ico-weather_3.png",
    "assets/img/ico-weather-03.png",
  ];

  void getTodayDiary() async{
    List<Diary> diary = await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));
    if(diary.isNotEmpty){
      todayDiary = diary.first;
    }
    setState(() {
      //
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodayDiary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: getPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Diary _d;
          if(todayDiary != null){
            _d = todayDiary;
          }else{
            _d = Diary(
                date: Utils.getFormatTime(DateTime.now()),
                title:"",
                memo: "",
                status: 0,
                image: "assets/img/b1.jpg"
            );
          }
          await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DiaryWritePage(
            diary : _d,
          )));
          getTodayDiary();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today),label: "오늘"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded),label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart),label: "통계"),
        ],
        onTap: (idx){
          setState((){
            selectIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage(){
    if(selectIndex == 0){
      return getTodayPage();
    }else if(selectIndex == 1){
      return getHistoryPage();
    }else{
      return getChartPage();
    }
  }

  Widget getTodayPage(){
    if(todayDiary == null){
      return Container(
        child: Text("일기 작성을 부탁합니다"),
      );
    }
    return Container(
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(todayDiary.image, fit: BoxFit.cover),),
          Positioned.fill(child: ListView(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${DateTime.now().month}.${DateTime.now().day}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                    Image.asset(statusImg[todayDiary.status], fit: BoxFit.contain,)
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todayDiary.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Container(height: 12,),
                    Text(todayDiary.memo, style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget getHistoryPage(){
    return Container();
  }

  Widget getChartPage(){
    return Container();
  }



}
