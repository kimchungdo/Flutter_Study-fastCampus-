import 'package:dietapp/data/data.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx){
            if(idx == 0){
              return Container(
                /*child: InkWell(
                    child: Image.asset(""),
                    onTap: (){}
                    ),*/
              );
            }
            else if(idx == 1){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("식사시간"),
                          Text("오전 11:32"),
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
                  margin: EdgeInsets.symmetric(horizontal: 16),
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
                margin: EdgeInsets.symmetric(horizontal: 16),
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
}