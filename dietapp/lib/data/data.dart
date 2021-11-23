
class Food {
  int id;
  int date;
  int type;
  int kcal;
  int time;
  String memo;
  String image;

  Food({this.time, this.date, this.image, this.id, this.kcal, this.memo, this.type});

  factory Food.fromDB(Map<String, dynamic> data){
    return Food(
      id: data["id"],
      date: data["date"],
      type: data["type"],
      kcal: data["kcal"],
      time: data["time"],
      memo: data["memo"],
      image: data["image"],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : this.id,
      "date" : this.date,
      "type" : this.type,
      "kcal" : this.kcal,
      "time" : this.time,
      "memo" : this.memo,
      "image" : this.image,
    };
  }

}



class Workout{
  int id;
  int date;
  int time;
  int kcal;
  int intense;
  int part;

  String name;
  String memo;

  Workout({this.memo, this.id, this.date, this.time, this.name, this.kcal, this.intense, this.part});

  factory Workout.fromDB(Map<String, dynamic>data){
    return Workout(
      id: data["id"],
      date: data["date"],
      time: data["time"],
      kcal: data["kcal"],
      intense: data["intense"],
      part: data["part"],
      name: data["name"],
      memo: data["memo"],
    );
  }
  Map <String, dynamic> toMap(){
    return {
      "id" : this.id,
      "date" : this.date,
      "time" : this.time,
      "kcal" : this.kcal,
      "intense" : this.intense,
      "part" : this.part,
      "name" : this.name,
      "memo" : this.memo,
    };
  }
}

class EyeBody {
  int id;
  int date;
  String image;
  String memo;

  EyeBody({this.date, this.image, this.id, this.memo});

  factory EyeBody.fromDB(Map<String, dynamic> data){
    return EyeBody(
      id: data["id"],
      date: data["date"],
      image: data["image"],
      memo: data["memo"],
    );
  }

  Map <String, dynamic> toMap(){
    return{
      "id" : this.id,
      "date" : this.date,
      "image" : this.image,
      "memo" : this.memo,
    };
  }
}

class Weight {
  int date;
  int weight;
  int fat;
  int muscle;

  Weight({this.date, this.weight, this.fat, this.muscle});

  factory Weight.fromDB(Map<String, dynamic> data){
    return Weight(
      date: data["date"],
      weight: data["weight"],
      fat: data["fat"],
      muscle: data["muscle"],
    );
  }

  Map <String, dynamic> toMap(){
    return{
      "date" : this.date,
      "weight" : this.weight,
      "fat" : this.fat,
      "muscle" : this.muscle,
    };
  }
}