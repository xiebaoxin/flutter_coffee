import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper.internal();
  factory UserDatabaseHelper() => _instance;
  final String tableName = "table_user";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  UserDatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName(user_id integer primary key,phone text not null,unit_id text not null, )");
    print("Table is created");
  }

//插入
  Future<int> saveItem(Map<String, dynamic> user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", user);
    print(res.toString());
    return res;
  }

  //查询
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ");
    return result.toList();
  }

  //查询总数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

//按照id查询
  Future<Map<String, dynamic>> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE user_id = $id");
    if (result.length == 0) return null;
    return result.first;
  }


  //清空数据
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }


  //根据id删除
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "user_id = ?", whereArgs: [id]);
  }

  //修改
  Future<int> updateItem(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", user,
        where: "user_id = ?", whereArgs: [user['user_id']]);
  }

  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
