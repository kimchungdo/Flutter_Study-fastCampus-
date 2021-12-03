import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../util.dart';

class WorkoutAddPage extends StatefulWidget {
  final Workout workout;

  WorkoutAddPage({Key key, this.workout}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WorkoutAddPageState();
  }
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  Workout get workout => widget.workout;
  TextEditingController memoController =
      TextEditingController(); //텍스트 필드 사용시에는 꼭필요하다
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    memoController.text = workout.memo;
    nameController.text = workout.name;
    distanceController.text = workout.distance.toString();
    timeController.text = workout.time.toString();
    calController.text = workout.kcal.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: txtColor),
        //백그라운드가 화이트이기 때문에 아이콘 테마를 설정해줘야한다. 버튼이 가려짐
        elevation: 1.0,
        actions: [
          TextButton(
            child: Text("저장"),
            onPressed: () {
              //저장하고 종료
              final db = DatabaseHelper.instance;
              workout.memo = memoController.text;
              workout.name = nameController.text;

              if (timeController.text.isEmpty) {
                workout.time = 0;
              } else {
                workout.time = int.parse(timeController.text);
              }
              if (calController.text.isEmpty) {
                workout.kcal = 0;
              } else {
                workout.kcal = int.parse(calController.text);
              }
              if (distanceController.text.isEmpty) {
                workout.distance = 0;
              } else {
                workout.distance = int.parse(distanceController.text);
              }

              db.insertWorkout(workout);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      backgroundColor: bgColor,
      body: Container(
          child: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(children: [
                  Container(
                    child: InkWell(
                      child: Image.asset("assets/img/${workout.type}.png"),
                      onTap: () {
                        setState(() {
                          workout.type++;
                          workout.type = workout.type % 4;
                        });
                      },
                    ),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: ibgColor,
                      borderRadius: BorderRadius.circular(70),
                    ),
                  ),
                  Container(height: 8),
                  Expanded(
                      child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: txtColor, width: 0.5)))))
                ]));
          } else if (idx == 1) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("운동 시간", style: mTS.apply(color: txtColor)),
                      Container(
                        child: TextField(
                            keyboardType: TextInputType.number,
                            //숫자만 입력 가능하게 만든다
                            controller: timeController,
                            textAlign: TextAlign.end,
                            style: mTS.apply(color: txtColor),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: txtColor, width: 0.5)))),
                        width: 70,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("운동 칼로리", style: mTS.apply(color: txtColor)),
                      Container(
                        child: TextField(
                            keyboardType: TextInputType.number,
                            //숫자만 입력 가능하게 만든다
                            controller: calController,
                            textAlign: TextAlign.end,
                            style: mTS.apply(color: txtColor),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: txtColor, width: 0.5)))),
                        width: 70,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("운동 거리", style: mTS.apply(color: txtColor)),
                      Container(
                        child: TextField(
                            keyboardType: TextInputType.number,
                            //숫자만 입력 가능하게 만든다
                            controller: distanceController,
                            textAlign: TextAlign.end,
                            style: mTS.apply(color: txtColor),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: txtColor, width: 0.5)))),
                        width: 70,
                      )
                    ],
                  ),
                ],
              ),
            );
          } else if (idx == 2) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("운동 부위", style: mTS.apply(color: txtColor)),
                    ],
                  ),
                  Container(height: 12),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    //그리드 뷰이지만 스크롤이 안되는 것으로 고정해버린다. 같은방향 리스트뷰같은게 두개이상이면 혼동옴
                    shrinkWrap: true,
                    children: List.generate(wPart.length, (_idx) {
                      return InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            wPart[_idx],
                            style: TextStyle(
                              color: workout.part == _idx
                                  ? Colors.white
                                  : iTxtColor, //클릭이 안됐으면 텍스트도 색깔 변화해야함
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            //각지지않게
                            color: workout.part == _idx ? mainColor : ibgColor,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            workout.part = _idx;
                          });
                        },
                      );
                    }),
                    crossAxisCount: 4,
                    //한줄에 몇개가 들어가는가      4개가 넘어가면 다음줄로 넘어감
                    crossAxisSpacing: 4,
                    //서로 붙어있지 않게
                    mainAxisSpacing: 4,
                    childAspectRatio: 2.5, //2 = 2:1 각 위젯의 비율
                  )
                ]));
          } else if (idx == 3) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("운동 강도", style: mTS.apply(color: txtColor)),
                    ],
                  ),
                  Container(height: 12),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    //그리드 뷰이지만 스크롤이 안되는 것으로 고정해버린다. 같은방향 리스트뷰같은게 두개이상이면 혼동옴
                    shrinkWrap: true,
                    children: List.generate(wIntense.length, (_idx) {
                      return InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            wIntense[_idx],
                            style: TextStyle(
                              color: workout.intense == _idx
                                  ? Colors.white
                                  : iTxtColor, //클릭이 안됐으면 텍스트도 색깔 변화해야함
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            //각지지않게
                            color:
                                workout.intense == _idx ? mainColor : ibgColor,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            workout.intense = _idx;
                          });
                        },
                      );
                    }),
                    crossAxisCount: 4,
                    //한줄에 몇개가 들어가는가      4개가 넘어가면 다음줄로 넘어감
                    crossAxisSpacing: 4,
                    //서로 붙어있지 않게
                    mainAxisSpacing: 4,
                    childAspectRatio: 2.5, //2 = 2:1 각 위젯의 비율
                  )
                ]));
          } else if (idx == 4) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("메모", style: mTS.apply(color: txtColor)),
                    Container(height: 12),
                    TextField(
                      maxLines: 10,
                      minLines: 10,
                      //minLine은 크게 볼 수 있게 만들어준다
                      keyboardType: TextInputType.multiline,
                      //여러줄 입력가능
                      controller: memoController,
                      //텍스트필드에 항상있어야함 2
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderSide: BorderSide(color: txtColor, width: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      )),
                    ),
                  ],
                ));
          }

          return Container();
        },
        itemCount: 5,
      )),
    );
  }
}

class MainWorkoutCard extends StatelessWidget {
  final Workout workout;

  MainWorkoutCard({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            //박스모양으로 묶어주기기
            borderRadius: BorderRadius.circular(12),
            color: bgColor,
            boxShadow: [
              //음영 넣어주기
              BoxShadow(
                blurRadius: 4,
                spreadRadius: 4,
                color: Colors.black12,
              )
            ]),
        child: ClipRRect(
            child: AspectRatio(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      child: Image.asset("assets/img/${workout.type}.png"),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: ibgColor,
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${Utils.makeTwoDigit(workout.time ~/ 60)}:"
                        "${Utils.makeTwoDigit(workout.time % 60)}",
                        textAlign: TextAlign.end,
                        style: lTS.apply(color: txtColor),
                      ),
                    )
                  ],
                ),
                Container(height: 8),
                Expanded(
                  child: Text(workout.name, style: mTS.apply(color: txtColor),),
                ),
                Text(workout.kcal == 0 ? "" : "${workout.kcal}kcal",style: sTS.apply(color: txtColor),),
                Text(workout.distance == 0 ? "" : "${workout.distance}km", style: sTS.apply(color: txtColor),),
              ],
            ),
          ),
          aspectRatio: 1,
        )));
  }
}
