
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'diary.dart';

class DatabaseHelper {
  static final _databaseName = "diary.db";
  static final _databaseVersion = 1;
  static final todoTable = "diary";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $todoTable (
        date INTEGER DEFAULT 0,
        title String,
        memo String,
        image String,
        status INTEGER DEFAULT 0
      )
      ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // 투두 입력, 수정, 불러오기
  Future<int> insertTodo(Diary diary) async {
    Database db = await instance.database;

    await getDiaryByDate(diary.date);

    List<Diary> d = await getDiaryByDate(diary.date);
    
    if(d.isEmpty){
      // 새로 추가
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "date": diary.date,
        "status": diary.status,
        "image": diary.image,
      };

      return await db.insert(todoTable, row);
    }else{
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "date": diary.date,
        "status": diary.status,
        "image": diary.image,
      };

      return await db.update(todoTable, row, where: "date = ?", whereArgs: [diary.date]);
    }

  }

  Future<List<Diary>> getAllDiary() async {
    Database db = await instance.database;
    List<Diary> diaries = [];

    var queries = await db.query(todoTable);

    for(var q in queries){
      diaries.add(Diary(
        title: q["title"],
        date: q["date"],
        image: q["image"],
        status: q["status"],
        memo: q["memo"],
      ));
    }

    return diaries;
  }

  Future<List<Diary>> getDiaryByDate(int date) async {
    Database db = await instance.database;
    List<Diary> diaries = [];

    var queries = await db.query(todoTable, where: "date = ?", whereArgs: [date]);

    for(var q in queries){
      diaries.add(Diary(
        title: q["title"],
        date: q["date"],
        image: q["image"],
        status: q["status"],
        memo: q["memo"],
      ));
    }

    return diaries;
  }

}