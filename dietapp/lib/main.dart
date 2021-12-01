import 'package:dietapp/style.dart';
import 'package:dietapp/util.dart';
import 'package:dietapp/view/body.dart';
import 'package:dietapp/view/food.dart';
import 'package:dietapp/view/workout.dart';
import 'package:flutter/material.dart';

import 'data/data.dart';
import 'data/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
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

  final dbHelper = DatabaseHelper.instance;

  int currentIndex = 0;           //BottomNavigation Bar 에 어떤 인덱스가 저장되어있는지를 확인, 이용
  DateTime dateTime = DateTime.now();

  List<Workout> workouts = [];
  List<Food> foods = [];
  List<EyeBody> bodies = [];
  List<Weight> weight = [];

  void getHistories() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    workouts = await dbHelper.queryWorkoutByDate(_d);
    bodies = await dbHelper.queryEyeBodyByDate(_d);
    //weight = await dbHelper.queryWeightByDate(_d);

    setState((){});
  }

  @override
  void initState(){
    super.initState();

    getHistories();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
                            date: Utils.getFormatTime(DateTime.now()),
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
                              date: Utils.getFormatTime(DateTime.now()),
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
                              date: Utils.getFormatTime(DateTime.now()),
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
        child: const Icon(Icons.add),
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
      ),
    );
  }

  Widget getPage(){
    if(currentIndex == 0){
      return getHomeWidget(DateTime.now());
    }

    return Container();

  }

  Widget getHomeWidget(DateTime date){                    //기록 탭과 홈 화면의 양식을 유사하게 만들기 위해 date를 인자로 전달하게끔함.
    return Container(
      child: Column(
        children: [
          Container(
            child: foods.isEmpty ? Image.asset("assets/img/food.jpg"):ListView.builder(               //그냥 리스트뷰 빌더를 사용하게 되면 오류 발생 Container를 통해 감싸서 높이를 지정해줘야만한다
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
            child: workouts.isEmpty ? Image.asset("assets/img/workout.png") : ListView.builder(               //그냥 리스트뷰 빌더를 사용하게 되면 오류 발생 Container를 통해 감싸서 높이를 지정해줘야만한다
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
          ),


          Container(
            child: ListView.builder(
              itemBuilder: (ctx,idx) {
                if(idx == 0){
                  //몸무게
                }else{
                  if(bodies.isEmpty){
                    return Container(
                      height: cardSize,
                      width: cardSize,
                      color: mainColor,
                    );
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


}
