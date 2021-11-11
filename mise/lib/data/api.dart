

import 'mise.dart';

class MiseApi {

  final BASE_URL = "http:/apis.data.go.kr";

  final String key = "CmsoBTw9QecEbRGS64lx2ovfYjhGGxAoe29AmU3Y6LoEuyXl%2BV7dZoonUFq20Skui3eZYUT9nJkAlkghW9N5XA%3D%3D";

  Future<List<Mise>> getMiseData(String stationName){
    String url = "$BASE_URL/B552584/ArpltnInforInqireSvc";
  }
}