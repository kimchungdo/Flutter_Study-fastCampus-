import 'package:flutter/material.dart';
import 'package:my_diary/write.dart';
import 'package:table_calendar/table_calendar.dart';

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
  Diary historyDiary;
  List<Diary> allDiaries = [];

  List<String> statusImg = [
    "assets/img/ico-weathe-02-r.png",
    "assets/img/ico-weather_3.png",
    "assets/img/ico-weather-03.png",
  ];
  DateTime time = DateTime.now();

  CalendarController calendarController = CalendarController();
  void getTodayDiary() async{
    List<Diary> diary = await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));
    if(diary.isNotEmpty){
      todayDiary = diary.first;
    }
    setState(() {
      //
    });
  }

  void getAllDiary() async{
    allDiaries = await dbHelper.getAllDiary();
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
          if(selectIndex == 0) {
            Diary _d;
            if (todayDiary != null) {
              _d = todayDiary;
            } else {
              _d = Diary(
                  date: Utils.getFormatTime(DateTime.now()),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/b1.jpg"
              );
            }
            await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                DiaryWritePage(
                  diary: _d,
                )));
            getTodayDiary();
          }else{
            Diary _d;
            if (historyDiary != null) {
              _d = historyDiary;
            } else {
              _d = Diary(
                  date: Utils.getFormatTime(time),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/b1.jpg"
              );
            }
            await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
                DiaryWritePage(
                  diary: _d,
                )));
            getDiaryByDate(time);
          }
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
        currentIndex: selectIndex,
        onTap: (idx){
          setState((){
            selectIndex = idx;
          });
          if(selectIndex == 2){
            getAllDiary();
          }
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
                    Image.asset(statusImg[todayDiary.status], fit: BoxFit.contain, width: 50, height: 50,)
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

  void getDiaryByDate(DateTime date) async {
    List<Diary> d = await dbHelper.getDiaryByDate(Utils.getFormatTime(date));
    setState(() {
      if(d.isEmpty){
        historyDiary = null;
      }else{
        historyDiary = d.first;
      }
    });
  }


  Widget getHistoryPage(){
    return Container(
      child: ListView.builder(itemBuilder: (ctx, idx){
        if(idx == 0){
          return Container(
            child: TableCalendar(calendarController: calendarController,
            onDaySelected: (date, events, holidays){
              print(date);
              time = date;
              getDiaryByDate(date);
              },
            ),
          );
        }else if(idx == 1){
          if(historyDiary == null){
            return Container();
          }
          return Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${time.month}.${time.day}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                    Image.asset(statusImg[historyDiary.status], fit: BoxFit.contain, width: 50, height: 50)
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
                    Text(historyDiary.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Container(height: 12,),
                    Text(historyDiary.memo, style: TextStyle(fontSize: 18),),
                    Image.asset(historyDiary.image, fit: BoxFit.cover)
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
        itemCount: 2,
      )
    );
  }

  Widget getChartPage(){
    return Container(
      child: ListView.builder(itemBuilder: (ctx, idx){
        if(idx==0){
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(statusImg.length, (_idx){
                return Container(
                  child: Column(
                    children: [
                      Image.asset(statusImg[_idx], fit: BoxFit.contain,width: 50, height: 50),
                      Text("${allDiaries.where((element) => element.status == _idx).length}개"),
                    ]
                  )
                );
              }),
            )
          );
        }else if(idx == 1){
          return Container(
            child: ListView(
              children: List.generate(allDiaries.length, (_idx){
                return Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(allDiaries[_idx].image, fit: BoxFit.cover,),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                );
              }
              ),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal:20)
            ),
            height: 120,
          );
        }
        return Container();
      },
      itemCount: 5,
      ),
    );
  }
  
}
