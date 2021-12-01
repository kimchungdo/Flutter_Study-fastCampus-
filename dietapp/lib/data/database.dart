

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data.dart';

class DatabaseHelper {
  static final _databaseName = "dietapp.db";
  static final int _databaseVersion = 2;              //버젼 변경시에 여기가 바뀔 것임
  static final foodTable = "food";
  static final workoutTable = "workout";
  static final bodyTable = "body";
  static final weightTable = "weight";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future <Database> get database async {
    if(_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion,
      onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS $foodTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date INTEGER DEFAULT 0,
    type INTEGER DEFAULT 0,
    meal INTEGER DEFAULT 0,
    kcal INTEGER DEFAULT 0,
    time INTEGER DEFAULT 0,
    image String,
    memo String
    )
    """);

    await db.execute("""
    CREATE TABLE IF NOT EXISTS $workoutTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date INTEGER DEFAULT 0,
    time INTEGER DEFAULT 0,
    type INTEGER DEFAULT 0,
    distance INTEGER DEFAULT 0,
    kcal INTEGER DEFAULT 0,
    intense INTEGER DEFAULT 0,
    part INTEGER DEFAULT 0,
    name String,
    memo String
    )
    """);

    await db.execute("""
    CREATE TABLE IF NOT EXISTS $bodyTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date INTEGER DEFAULT 0,
    image String,
    memo String
    )
    """);

    await db.execute("""
    CREATE TABLE IF NOT EXISTS $weightTable (
    date INTEGER DEFAULT 0,
    weight INTEGER DEFAULT 0,
    fat INTEGER DEFAULT 0,
    muscle INTEGER DEFAULT 0
    )
    """);

  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if(newVersion == 2){                          //기존에 만들었던 테이블에 두가지를 추가해 줄 수 있음 업그레이드해주는거임
      await db.execute("""
      ALTER TABLE $workoutTable
      ADD type INTEGER DEFAULT 0
      """);

      await db.execute("""
      ALTER TABLE $workoutTable
      ADD distance INTEGER DEFAULT 0
      """);
    }
  }


  //데이터 추가, 변경, 검색, 삭제
  Future<int> insertFood (Food food) async {
    Database db = await instance.database;

    if(food.id == null){
      //생성
      final _map = food.toMap();

      return await db.insert(foodTable, _map);
    }else{
      //변경
      final _map = food.toMap();
      return await db.update(foodTable, _map, where: "id = ?", whereArgs:  [food.id]);
    }
  }

  Future<List<Food>> queryFoodByDate(int date) async {
    Database db = await instance.database;

    List<Food> foods = [];

    final query = await db.query(foodTable, where: "date = ?", whereArgs: [date]);

    for(final q in query){
      foods.add(Food.fromDB(q));
    }

    return foods;

  }

  Future<List<Food>> queryAllFood() async {
    Database db = await instance.database;

    List<Food> foods = [];

    final query = await db.query(foodTable);

    for(final q in query){
      foods.add(Food.fromDB(q));
    }

    return foods;

  }


  //데이터 추가, 변경, 검색, 삭제
  Future<int> insertWorkout (Workout workout) async {
    Database db = await instance.database;

    if(workout.id == null){
      //생성
      final _map = workout.toMap();

      return await db.insert(workoutTable, _map);
    }else{
      //변경
      final _map = workout.toMap();
      return await db.update(workoutTable, _map, where: "id = ?", whereArgs:  [workout.id]);
    }
  }

  Future<List<Workout>> queryWorkoutByDate(int date) async {
    Database db = await instance.database;

    List<Workout> workouts = [];

    final query = await db.query(workoutTable, where: "date = ?", whereArgs: [date]);

    for(final q in query){
      workouts.add(Workout.fromDB(q));
    }

    return workouts;

  }

  Future<List<Workout>> queryAllWorkout() async {
    Database db = await instance.database;

    List<Workout> workouts = [];

    final query = await db.query(workoutTable);

    for(final q in query){
      workouts.add(Workout.fromDB(q));
    }

    return workouts;

  }

  ///////



  //데이터 추가, 변경, 검색, 삭제
  Future<int> insertEyeBody (EyeBody workout) async {
    Database db = await instance.database;

    if(workout.id == null){
      //생성
      final _map = workout.toMap();

      return await db.insert(bodyTable, _map);
    }else{
      //변경
      final _map = workout.toMap();
      return await db.update(bodyTable, _map, where: "id = ?", whereArgs:  [workout.id]);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database db = await instance.database;

    List<EyeBody> workouts = [];

    final query = await db.query(bodyTable, where: "date = ?", whereArgs: [date]);

    for(final q in query){
      workouts.add(EyeBody.fromDB(q));
    }

    return workouts;

  }

  Future<List<EyeBody>> queryAllEyebody() async {
    Database db = await instance.database;

    List<EyeBody> workouts = [];

    final query = await db.query(workoutTable);

    for(final q in query){
      workouts.add(EyeBody.fromDB(q));
    }

    return workouts;

  }




  //데이터 추가, 변경, 검색, 삭제
  Future<int> insertWeight (Weight workout) async {
    Database db = await instance.database;

    List<Weight> _d = await queryWeightByDate(workout.date);

    if(_d.isEmpty){
      //생성
      final _map = workout.toMap();

      return await db.insert(weightTable, _map);
    }else{
      //변경
      final _map = workout.toMap();
      return await db.update(weightTable, _map, where: "date = ?", whereArgs:  [workout.date]);
    }
  }

  Future<List<Weight>> queryWeightByDate(int date) async {
    Database db = await instance.database;

    List<Weight> workouts = [];

    final query = await db.query(weightTable, where: "date = ?", whereArgs: [date]);

    for(final q in query){
      workouts.add(Weight.fromDB(q));
    }

    return workouts;

  }

  Future<List<Weight>> queryAllWeight() async {
    Database db = await instance.database;

    List<Weight> workouts = [];

    final query = await db.query(weightTable);

    for(final q in query){
      workouts.add(Weight.fromDB(q));
    }

    return workouts;

  }


}