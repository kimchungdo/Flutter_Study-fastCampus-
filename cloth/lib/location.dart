

import 'package:cloth/data/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage>{
  List<LocationData> locations = [
    LocationData(lat: 37.498122, lng: 127.027565, name: "강남구", x: 0, y: 0),
    LocationData(lat: 37.502413, lng: 126.953647, name: "동작구"),
    LocationData(lat: 37.560502, lng: 126.907612, name: "마포구"),
    LocationData(lat: 37.556723, lng: 127.035401, name: "성동구"),
    LocationData(lat: 37.47681, lng: 127.94704, name: "관악구"),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        children: List.generate(locations.length, (idx) {
          return ListTile(
            title: Text(locations[idx].name),
            trailing: Icon(Icons.arrow_forward),
            onTap: (){
              Navigator.of(context).pop(locations[idx]);
            },
          );
        }),
      )
    );
  }
}