import 'package:dietapp/style.dart';
import 'package:dietapp/util.dart';
import 'package:dietapp/view/body.dart';
import 'package:dietapp/view/food.dart';
import 'package:dietapp/view/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';

import 'data/data.dart';
import 'data/database.dart';
import 'package:timezone/timezone.dart' as tz;              //알림 임포트
import 'package:timezone/data/latest.dart' as tz;           //먼저 임포트 알림

import 'package:intl/date_symbol_data_local.dart';                //한국어 달력 설정 관련


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;            //그다음에 변수생성 알림
void main() async {
  initializeDateFormatting().then((_){              //한국어 달력 설정 관련
    runApp(const MyApp());
  });



  tz.initializeTimeZones();
  
  const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel("fastcampus", "dietapp", "dietapp");              //알림 관련 채널을 생성
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);  //플랫폼 내에 채널을 만들어라
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: mainMColor,
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

  final dbHelper = DatabaseHelper.instance;

  int currentIndex = 0;           //BottomNavigation Bar 에 어떤 인덱스가 저장되어있는지를 확인, 이용
  DateTime dateTime = DateTime.now();

  List<Workout> workouts = [];
  List<Workout> allWorkouts = [];
  List<Food> foods = [];
  List<Food> allFoods = [];
  List<EyeBody> bodies = [];
  List<EyeBody> allBodies = [];
  List<Weight> weight = [];
  List<Weight> weights = [];


  //알림 초기화 및 알림 설정

  Future<bool> initNotification() async {
    if(flutterLocalNotificationsPlugin == null){
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    }

    var initSettingAndroid = AndroidInitializationSettings("app_icon");
    var initiOSSetting = IOSInitializationSettings();

    var initSetting = InitializationSettings(
      android: initSettingAndroid, iOS: initiOSSetting
    );

    await flutterLocalNotificationsPlugin.initialize(initSetting, onSelectNotification: (payload) async {

    });

    setScheduling();
    return true;

  }

 void getHistories() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    workouts = await dbHelper.queryWorkoutByDate(_d);
    bodies = await dbHelper.queryEyeBodyByDate(_d);
    weight = await dbHelper.queryWeightByDate(_d);
    weights = await dbHelper.queryAllWeight();
    allFoods = await dbHelper.queryAllFood();
    allWorkouts = await dbHelper.queryAllWorkout();
    allBodies = await dbHelper.queryAllEyebody();

    if(weight.isNotEmpty){
      final w = weight.first;
      wCtrl.text = w.weight.toString();
      mCtrl.text = w.muscle.toString();
      fCtrl.text = w.fat.toString();
    }else{
      wCtrl.text = "";
      mCtrl.text = "";
      fCtrl.text = "";
    }

    setState((){});
  }

  @override
  void initState(){
    super.initState();

    getHistories();
    initNotification();
  }

  void setScheduling(){                                                                   //알림 알람 스케쥴링 중요도 우선순위 등
    var android = AndroidNotificationDetails("fastcampus", "dietapp", "dietapp",
      importance: Importance.max,
      priority: Priority.max
    );
    var ios = IOSNotificationDetails();

    NotificationDetails detail = NotificationDetails(
      iOS: ios,
      android: android,
    );
    
    flutterLocalNotificationsPlugin.zonedSchedule(0, "오늘의 다이어트를 기록해주세요!", "앱을 실행해 주세요!", tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 10)), tz.local) //앱을 키고 10초 뒤에 오는지 확인
        , detail, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true, payload: "dietapp",
        matchDateTimeComponents: DateTimeComponents.time);                     //이게 중요한거임 매일매일 몇시에 알람이 오는가 => time/          dayOfWeekAndTime 은 매주 화요일 5시 등 이렇게
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(child: AppBar(),                       //앱바 없애는 방법임
        preferredSize: Size.fromHeight(0),
      ),
      backgroundColor: bgColor,
      body: getPage(),
      floatingActionButton: ![0,1].contains(currentIndex)? Container() : FloatingActionButton(
        onPressed: (){
          setState(() {
            changeToDarkMode();
          });



          showModalBottomSheet(context: context, backgroundColor: bgColor,              //FAB버튼 클릭시 등장하는 선택가능한 클릭창 발현
          builder: (ctx){
            return SizedBox(
              height: 250,
              child: Column(
                children: [
                  TextButton(
                    child: Text("식단"),
                    onPressed: ()async {                 //페이지 이동시 사용방법 암기하자 제발 좀
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => FoodAddPage(
                          food: Food(
                            date: Utils.getFormatTime(dateTime),
                            kcal: 0,
                            memo: "",
                            type: 0,
                            meal: 0,
                            image: "",
                            time: 1130,
                          ),
                        ))
                      );
                      getHistories();
                    },
                  ),
                  TextButton(
                    child: Text("운동"),
                    onPressed: ()async {                 //페이지 이동시 사용방법 암기하자 제발 좀
                      await Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => WorkoutAddPage(
                            workout: Workout(
                              date: Utils.getFormatTime(dateTime),
                              time: 60,
                              kcal: 0,
                              intense: 0,
                              distance: 0,
                              memo: "",
                              type: 0,
                              name: "",
                              part: 0,
                            ),
                          ))
                      );
                      getHistories();
                    },
                  ),
                  TextButton(
                    child: Text("몸무게"),
                    onPressed: (){},
                  ),TextButton(
                    child: Text("눈바디"),
                    onPressed: ()async{
                      await Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => EyeBodyAddPage(
                            body: EyeBody(
                              date: Utils.getFormatTime(dateTime),
                              memo: "",
                              image: "",
                            ),
                          ))
                      );
                      getHistories();
                    },
                  ),

                ],
              )
            );
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "오늘"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "기록"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: "몸무게"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "통계"
          ),
        ],
        currentIndex: currentIndex,                   //여기서 현재 인덱스를 확인후 페이지 전환 작업 이루어짐
        onTap: (idx){
          setState(() {
            currentIndex = idx;                      //선택되었을때 idx(현재 페이지의 인덱스번호)를 커렌트에 넣어주며 페이지 전환작업을 상태설정함
          });
        },
        backgroundColor: bgColor,
        unselectedItemColor: txtColor,
      ),
    );
  }

  Widget getPage(){
    if(currentIndex == 0){
      return getHomeWidget(DateTime.now());
    }else if(currentIndex == 1){
      return getHistoryWidget();
    }else if(currentIndex == 2){
      return getWeightWidget();
    }else if(currentIndex==3){
      return getStaticsticWidget();
    }

    return Container();

  }

  Widget getHomeWidget(DateTime date){                    //기록 탭과 홈 화면의 양식을 유사하게 만들기 위해 date를 인자로 전달하게끔함.
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: foods.isEmpty ? Container(
              padding: EdgeInsets.all(8),
                child: ClipRRect(child: Image.asset("assets/img/food.jpg"), borderRadius: BorderRadius.circular(12),)):ListView.builder(               //그냥 리스트뷰 빌더를 사용하게 되면 오류 발생 Container를 통해 감싸서 높이를 지정해줘야만한다
              itemBuilder: (ctx,idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  child: MainFoodCard(food: foods[idx]),
                );
              },
              itemCount: foods.length,
              scrollDirection: Axis.horizontal,
            ),
            height: cardSize,
          ),

          Container(
            child: workouts.isEmpty ? Container(
              padding: EdgeInsets.all(8),
                child: ClipRRect(child: Image.asset("assets/img/workout.png"), borderRadius: BorderRadius.circular(12),)) : ListView.builder(               //그냥 리스트뷰 빌더를 사용하게 되면 오류 발생 Container를 통해 감싸서 높이를 지정해줘야만한다
              itemBuilder: (ctx,idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  child: MainWorkoutCard(workout: workouts[idx],),
                );
              },
              itemCount: workouts.length,
              scrollDirection: Axis.horizontal,
            ),
            height: cardSize,
            width: cardSize,
          ),


          Container(
            child: ListView.builder(
              itemBuilder: (ctx,idx) {
                if(idx == 0){
                  //몸무게
                  if(weight.isEmpty){
                    return Container();
                  }else{
                    final w = weight.first;

                    return Container(
                      child: Container(
                        height: cardSize,
                        width: cardSize,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 4,
                              blurRadius: 4,
                            )
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${w.weight}kg", style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: txtColor
                            ),)
                          ],
                        )
                      ),
                      height: cardSize,
                      width: cardSize,
                    );
                  }
                }else{
                  if(bodies.isEmpty){
                    return Container(
                        padding: EdgeInsets.all(8),
                        child: ClipRRect(child: Image.asset("assets/img/body3x.png"), borderRadius: BorderRadius.circular(12),));
                  }
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainEyeBodyCard(eyeBody: bodies[0],),           //하나바껭없음
                  );
                }
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
              itemCount: 2,
              scrollDirection: Axis.horizontal,
            ),
            height: cardSize + 20,
          ),
        ],
      )
    );
  }

  CalendarController calendarController = CalendarController();

  Widget getHistoryWidget(){
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx){
          if(idx == 0){
            return Container(
              child: TableCalendar(
                locale: "ko-KR",
                initialSelectedDay: dateTime,
                calendarController: calendarController,
                onDaySelected: (date, events, holidays){
                  dateTime = date;
                  getHistories();
                },
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true
                ),
                calendarStyle: CalendarStyle(
                  selectedColor: mainColor
                ),
                initialCalendarFormat: CalendarFormat.month,
                availableCalendarFormats: {
                  CalendarFormat.month:""
                },
              )
            );
          }else if (idx == 1){
            return getHomeWidget(dateTime);
          }
          return Container();
        },
        itemCount: 2,
      )
    );
  }

  CalendarController weightCalendarController = CalendarController();
  TextEditingController wCtrl = TextEditingController();               //몸무게
  TextEditingController mCtrl = TextEditingController();                       //muscle
  TextEditingController fCtrl = TextEditingController();                  //fat
  int chartIndex = 0;

  Widget getWeightWidget(){
    return Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx){
            if(idx == 0){
              return Container(
                  child: TableCalendar(
                    locale: "ko-KR",
                    key: Key("weightCalendar"),
                    initialSelectedDay: dateTime,
                    calendarController: weightCalendarController,
                    onDaySelected: (date, events, holidays){
                      dateTime = date;
                      getHistories();
                    },
                    headerStyle: HeaderStyle(
                        centerHeaderTitle: true
                    ),
                    initialCalendarFormat: CalendarFormat.week,
                    availableCalendarFormats: {
                      CalendarFormat.week:""
                    },
                  )
              );
            }else if (idx == 1){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${dateTime.month}월 ${dateTime.day}일"),
                        InkWell(
                          child: Container(
                            child: Text("저장"),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onTap: () async {
                            Weight w;
                            if(weight.isEmpty){
                              //몸무게를 처음 입력하는 것이다
                              w = Weight(date: Utils.getFormatTime(dateTime));
                            }else{
                              //처음입력이아니다
                              w = weight.first;
                            }

                            w.weight = int.tryParse(wCtrl.text) ?? 0;
                            w.muscle = int.tryParse(mCtrl.text) ?? 0;
                            w.fat = int.tryParse(fCtrl.text) ?? 0;

                            FocusScope.of(context).unfocus();              //저장버튼 누르면 키보드 사라짐
                            await dbHelper.insertWeight(w);
                            getHistories();
                          },
                        )
                      ],
                    ),

                    Container(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(width: 8),
                              Text("몸무게"),
                              TextField(
                                  keyboardType: TextInputType.number,              //숫자만 입력 가능하게 만든다
                                  controller: wCtrl,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: txtColor,
                                              width: 0.5
                                          )
                                      )
                                  )
                              )
                            ],
                          )
                        ),
                        Container(width: 8),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("근육량"),
                                TextField(
                                    keyboardType: TextInputType.number,              //숫자만 입력 가능하게 만든다
                                    controller: mCtrl,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: txtColor,
                                                width: 0.5
                                            )
                                        )
                                    )
                                )
                              ],
                            )
                        ),
                        Container(width: 8),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("지방"),
                                TextField(
                                    keyboardType: TextInputType.number,              //숫자만 입력 가능하게 만든다
                                    controller: fCtrl,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: txtColor,
                                                width: 0.5
                                            ),
                                          borderRadius: BorderRadius.circular(8)
                                        )
                                    ),
                                )
                              ],
                            ),
                        ),
                        Container(width: 8),
                      ]
                    )
                  ],
                ),
              );
            }

            else if (idx == 2){
              List<FlSpot> spots = [];

              for(final w in weights){
                if(chartIndex == 0){
                  //몸무게
                  spots.add(FlSpot(w.date.toDouble(), w.weight.toDouble()));
                }else if(chartIndex == 1){
                  //근육량
                  spots.add(FlSpot(w.date.toDouble(), w.muscle.toDouble()));
                }else{
                  //지방
                  spots.add(FlSpot(w.date.toDouble(), w.fat.toDouble()));
                }
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            child: Text("몸무게", style: TextStyle(
                              color: chartIndex == 0 ? Colors.white : iTxtColor
                            ),),
                            decoration: BoxDecoration(
                                color: chartIndex == 0 ? mainColor : ibgColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onTap: () async {
                            setState(() {
                              chartIndex = 0;
                            });
                          },
                        ),
                        Container(width: 8),
                        InkWell(
                          child: Container(
                            child: Text("근육량", style: TextStyle(
                                color: chartIndex == 1 ? Colors.white : iTxtColor
                            ),),
                            decoration: BoxDecoration(
                                color: chartIndex == 1 ? mainColor : ibgColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onTap: () async {
                            setState(() {
                              chartIndex = 1;
                            });
                          },
                        ),
                        Container(width: 8),
                        InkWell(
                          child: Container(
                            child: Text("지방", style: TextStyle(
                                color: chartIndex == 2 ? Colors.white : iTxtColor
                            ),),
                            decoration: BoxDecoration(
                                color: chartIndex == 2 ? mainColor : ibgColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onTap: () async {
                            setState(() {
                              chartIndex = 2;
                            });
                          },
                        ),

                      ],
                    ),
                    Container(
                      height: 300,
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 4,
                              color: Colors.black12,
                            )
                          ]
                        ),
                        child: spots.isEmpty ? Container() : LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                colors: [mainColor]
                              )
                            ],
                            gridData: FlGridData(
                              show: false
                            ),
                            borderData: FlBorderData(
                              show: false
                            ),
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (spots){
                                  return[
                                    LineTooltipItem(
                                      "${spots.first.y}kg", TextStyle(color: mainColor)
                                    )
                                  ];
                                }
                              )
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value){
                                  DateTime date = Utils.stringToDateTime(value.toInt().toString());
                                  return "${date.day}일";

                                }
                              ),
                              leftTitles: SideTitles(
                                showTitles: false
                              ),
                            )
                          )
                        )
                    )
                  ],
                )
              );
            }
            return Container();
          },
          itemCount: 3,
        )
    );
  }


  Widget getStaticsticWidget(){
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx){
          if(idx == 0) {
              List<FlSpot> spots = [];

              for(final w in allWorkouts){
                if(chartIndex == 0){
                  //몸무게
                  spots.add(FlSpot(w.date.toDouble(), w.time.toDouble()));
                }else if(chartIndex == 1){
                  //근육량
                  spots.add(FlSpot(w.date.toDouble(), w.kcal.toDouble()));
                }else{
                  //지방
                  spots.add(FlSpot(w.date.toDouble(), w.distance.toDouble()));
                }
              }

              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: Container(
                              child: Text("운동 시간", style: TextStyle(
                                  color: chartIndex == 0 ? Colors.white : iTxtColor
                              ),),
                              decoration: BoxDecoration(
                                  color: chartIndex == 0 ? mainColor : ibgColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            onTap: () async {
                              setState(() {
                                chartIndex = 0;
                              });
                            },
                          ),
                          Container(width: 8),
                          InkWell(
                            child: Container(
                              child: Text("칼로리", style: TextStyle(
                                  color: chartIndex == 1 ? Colors.white : iTxtColor
                              ),),
                              decoration: BoxDecoration(
                                  color: chartIndex == 1 ? mainColor : ibgColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            onTap: () async {
                              setState(() {
                                chartIndex = 1;
                              });
                            },
                          ),
                          Container(width: 8),
                          InkWell(
                            child: Container(
                              child: Text("거리", style: TextStyle(
                                  color: chartIndex == 2 ? Colors.white : iTxtColor
                              ),),
                              decoration: BoxDecoration(
                                  color: chartIndex == 2 ? mainColor : ibgColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            onTap: () async {
                              setState(() {
                                chartIndex = 2;
                              });
                            },
                          ),

                        ],
                      ),
                      Container(
                          height: 300,
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 16),
                          decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 4,
                                  color: Colors.black12,
                                )
                              ]
                          ),
                          child: spots.isEmpty ? Container() : LineChart(
                              LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                        spots: spots,
                                        colors: [mainColor]
                                    )
                                  ],
                                  gridData: FlGridData(
                                      show: false
                                  ),
                                  borderData: FlBorderData(
                                      show: false
                                  ),
                                  lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                          getTooltipItems: (spots){
                                            return[
                                              LineTooltipItem(
                                                  "${spots.first.y}", TextStyle(color: mainColor)
                                              )
                                            ];
                                          }
                                      )
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: SideTitles(
                                        showTitles: true,
                                        getTitles: (value){
                                          DateTime date = Utils.stringToDateTime(value.toInt().toString());
                                          return "${date.day}일";

                                        }
                                    ),
                                    leftTitles: SideTitles(
                                        showTitles: false
                                    ),
                                  )
                              )
                          )
                      )
                    ],
                  )
              );
            } else if (idx == 1){
            return Container(
              height: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx,_idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainFoodCard(food: allFoods[_idx],),
                  );
                },
                itemCount: allFoods.length,
                scrollDirection: Axis.horizontal,
              ),
            );
          }else if (idx == 2){
            return Container(
              height: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx,_idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainWorkoutCard(workout: allWorkouts[_idx],),
                  );
                },
                itemCount: allWorkouts.length,
                scrollDirection: Axis.horizontal,
              ),
            );
          }else if (idx == 3){
            return Container(
              height: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx,_idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainEyeBodyCard(eyeBody: allBodies[_idx],),
                  );
                },
                itemCount: allBodies.length,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
          return Container();
        },
        itemCount: 4,
      )
    );
  }
}
