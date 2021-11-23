

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data.dart';

class DatabaseHelper {
  static final _databaseName = "dietapp.db";
  static final int _databaseVersion = 1;
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
    muscle INTEGER DEFAULT 0,
    )
    """);

  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    //
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
      return await db.update(foodTable, _map, whereArgs:  [food.id]);
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
      return await db.update(workoutTable, _map, whereArgs:  [workout.id]);
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

}