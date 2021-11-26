import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../util.dart';

class FoodAddPage extends StatefulWidget{
  final Food food;

  FoodAddPage({Key key, this.food}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FoodAddPageState();
  }

}

class _FoodAddPageState extends State<FoodAddPage>{

  Food get food => widget.food;          //넘어온 푸드를 여기서 접근가능하게 만들어준다
  TextEditingController memoController = TextEditingController();          //텍스트 필드 사용시에는 꼭필요하다


  @override
  void initState() {
    // TODO: implement initState
    memoController.text = food.memo;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: txtColor),                //백그라운드가 화이트이기 때문에 아이콘 테마를 설정해줘야한다. 버튼이 가려짐
        elevation: 1.0,
        actions: [
          TextButton(
            child: Text("저장"),
            onPressed: (){
              //저장하고 종료
              final db = DatabaseHelper.instance;
              food.memo = memoController.text;

              db.insertFood(food);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx){
            if(idx == 0){
              return Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                height: cardSize,
                width: cardSize,
                child: InkWell(
                    child: AspectRatio(child: Align(child: food.image.isEmpty ? Image.asset("assets/img/food.jpg") :
                    AssetThumb(asset: Asset(food.image, "food.jpg", 0, 0),
                    width: cardSize.toInt(), height: cardSize.toInt(),),
                    ),
                    aspectRatio: 1/1,
                    ),
                    onTap: (){
                      selectImage();
                    },
                    ),
              );
            }
            else if(idx == 1){
              String _t = food.time.toString();
              
              String _m = _t.substring(_t.length - 2);
              String _h = _t.substring(0, _t.length - 2);
              TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
              //_t.replaceAll(_m, replace)
              return Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("식사시간"),
                          InkWell(child: Text("${time.hour > 11 ? "오후 " : "오전 "}${Utils.makeTwoDigit(time.hour % 12)}:${Utils.makeTwoDigit(time.minute)}"),
                          onTap: () async {
                            TimeOfDay _time = await showTimePicker(                     //시간을 가져온다
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if(_time == null){
                              return;
                            }

                            setState(() {
                              food.time = int.parse("${_time.hour}${Utils.makeTwoDigit(_time.minute)}");           //디비에 저장가능한 형태로 만들기
                            });



                          },),
                        ],
                    ),
                    Container(height: 12),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),                   //그리드 뷰이지만 스크롤이 안되는 것으로 고정해버린다. 같은방향 리스트뷰같은게 두개이상이면 혼동옴
                      shrinkWrap: true,
                      children: List.generate(mealTime.length, (_idx){
                        return InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(mealTime[_idx],
                            style: TextStyle(
                              color: food.meal == _idx ? Colors.white : iTxtColor,            //클릭이 안됐으면 텍스트도 색깔 변화해야함
                            ),),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),         //각지지않게
                              color: food.meal == _idx ? mainColor : ibgColor,
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              food.meal = _idx;
                            });
                          },
                        );
                      }),
                      crossAxisCount: 4,               //한줄에 몇개가 들어가는가      4개가 넘어가면 다음줄로 넘어감
                      crossAxisSpacing: 4,                //서로 붙어있지 않게
                      mainAxisSpacing: 4,
                      childAspectRatio: 2.5,              //2 = 2:1 각 위젯의 비율
                    )
                  ]
                )
              );
            }
            else if (idx == 2){
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text("식단 평가"),
                          ],
                        ),
                        Container(height: 12),
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),                   //그리드 뷰이지만 스크롤이 안되는 것으로 고정해버린다. 같은방향 리스트뷰같은게 두개이상이면 혼동옴
                          shrinkWrap: true,
                          children: List.generate(mealType.length, (_idx){
                            return InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(mealType[_idx],
                                  style: TextStyle(
                                    color: food.type == _idx ? Colors.white : iTxtColor,            //클릭이 안됐으면 텍스트도 색깔 변화해야함
                                  ),),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),         //각지지않게
                                  color: food.type == _idx ? mainColor : ibgColor,
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  food.type = _idx;
                                });
                              },
                            );
                          }),
                          crossAxisCount: 4,               //한줄에 몇개가 들어가는가      4개가 넘어가면 다음줄로 넘어감
                          crossAxisSpacing: 4,                //서로 붙어있지 않게
                          mainAxisSpacing: 4,
                          childAspectRatio: 2.5,              //2 = 2:1 각 위젯의 비율
                        )
                      ]
                  )
              );
            }
            else if(idx == 3){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("메모"),
                    Container(height: 12),
                    TextField(
                      maxLines: 10,
                      minLines: 10,                //minLine은 크게 볼 수 있게 만들어준다
                      keyboardType: TextInputType.multiline,             //여러줄 입력가능
                      controller: memoController,                                             //텍스트필드에 항상있어야함 2
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: txtColor, width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                    ),
                  ],
                )
              );
            }

            return Container();
          },
          itemCount: 4,
        )
      ),
    );
  }


  Future<void> selectImage() async {
    final _img = await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);                     //이미지 가져오기 관련 권한은 androidmanifest에 있음

    if(_img.length < 1){
      return;
    }

    setState((){
      food.image = _img.first.identifier;               //이미지 접근 가능한 키 같은 거임임
    });


  }
}