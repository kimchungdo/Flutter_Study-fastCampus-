import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/preference.dart';
import 'data/weather.dart';

class ClothPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ClothPageState();
  }
}

class _ClothPageState extends State<ClothPage> {
  List<ClothTmp> clothes = [];

  List<List<String>> sets = [
    ["assets/img/jumper.png", "assets/img/long.png", "assets/img/short.png"],
    ["assets/img/jumper1.png", "assets/img/skirts1.png", "assets/img/shirts1.png"],
  ];

  void getCloth() async{
    final pref = Preference();
    clothes = await pref.getTmp();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCloth();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: List.generate(clothes.length, (idx){
          return InkWell(
            child: Container(
              child: Column(
                children: [
                  Text("${clothes[idx].tmp}℃"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(clothes[idx].cloth.length, (_idx){
                      return Container(
                        padding: EdgeInsets.all(8),
                        width: 100,
                        height: 100,
                        child: Image.asset(clothes[idx].cloth[_idx], fit: BoxFit.contain),
                      );
                    }),
                  ),
                ],
              )
            ),
            onTap: (){
              showDialog(context: context, builder: (ctx){
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(sets.length, (_idx){
                      return InkWell(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(sets[_idx].length, (__idx){
                              return Container(
                                padding: EdgeInsets.all(8),
                                width: 50,
                                height: 50,
                                child: Image.asset(sets[_idx][__idx], fit: BoxFit.contain),
                              );
                            }),
                          ),
                        ),
                        onTap: () async {
                          clothes[idx].cloth = sets[_idx];
                          final pref = Preference();
                          await pref.setTmp(clothes[idx]);
                          Navigator.of(context).pop();
                          setState(() {
                          });
                        },
                      );
                    }),
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("닫기"),)
                  ]
                );
              });
            },
          );
        }),
      )
    );
  }
}