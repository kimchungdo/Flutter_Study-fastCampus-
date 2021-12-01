import 'package:dietapp/data/data.dart';
import 'package:dietapp/data/database.dart';
import 'package:dietapp/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../util.dart';

class EyeBodyAddPage extends StatefulWidget{
  final EyeBody body;

  EyeBodyAddPage({Key key, this.body}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EyeBodyAddPageState();
  }

}

class _EyeBodyAddPageState extends State<EyeBodyAddPage>{

  EyeBody get body => widget.body;          //넘어온 푸드를 여기서 접근가능하게 만들어준다
  TextEditingController memoController = TextEditingController();          //텍스트 필드 사용시에는 꼭필요하다


  @override
  void initState() {
    // TODO: implement initState
    memoController.text = body.memo;
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
              body.memo = memoController.text;

              db.insertEyeBody(body);
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
                    child: AspectRatio(child: Align(child: body.image.isEmpty ? Image.asset("assets/img/body3x.png") :
                    AssetThumb(asset: Asset(body.image, "body.jpg", 0, 0),
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
          itemCount: 3,
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
      body.image = _img.first.identifier;               //이미지 접근 가능한 키 같은 거임임
    });


  }
}

class MainEyeBodyCard extends StatelessWidget {
  final EyeBody eyeBody;
  MainEyeBodyCard({Key key, this.eyeBody}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(8),
      child: ClipRRect(                     //전체적으로 둥글게 만들어줌
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(                   //정사각형 모양을 1대 1로 만들어주기 위함
          child: Stack(
            children: [
              Positioned.fill(                          //스택의 전체를 채우겠다는 것을 의미함
                child: AssetThumb(asset: Asset(eyeBody.image, "food.jpg", 0, 0),
                    width: cardSize.toInt(), height: cardSize.toInt()),
              ),

              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                ),
              ),


            ],
          ),
          aspectRatio: 1,),
      ),
    );
  }

}