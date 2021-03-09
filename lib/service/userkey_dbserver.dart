import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserKeyDatabaseHelper {
  static final UserKeyDatabaseHelper _instance =
      UserKeyDatabaseHelper.internal();
  factory UserKeyDatabaseHelper() => _instance;
  final String tableName = "user_openkey";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  UserKeyDatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName(key_id integer primary key,user_id integer not null,key_mac text not null ,key_name text not null,key_key text not null)");
    print("Table is created");
  }

//插入
  Future<int> saveItem(int userId,List<Map<String, dynamic>> keyList) async {
    var dbClient = await db;
    int res = 0;

     await dbClient
        .delete(tableName, where: "user_id = ?", whereArgs: [userId]).then((v){
       keyList.forEach((v) async{
         Map<String, dynamic> iv = {
           "key_id": v['RID'],
           "user_id": userId,
           "key_mac": "${v['LOCKMAC_0']}",
           "key_name": "${v['LOCKNAME']}",
           "key_key":v['OPENWORD']??"888888"
         };
         res = await dbClient.insert("$tableName", iv);
       });
     });

    return res;
  }

  Future<List> test() async {
    var dbClient = await db;
    Map<String, dynamic> iv = {
      "key_id": 1,
      "user_id": 1,
      "key_mac": "23sdfafe24",
      "key_name": "test",
      "key_key": "23243"
    };


     int res = await dbClient.insert("$tableName", iv);
      print(res);
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ");// WHERE user_id = $user_id
    print(result);
    print("----1010-------");
    return result.toList();
  }

  //查询
  Future<List> getKeyList(String userId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT key_id as RID,key_mac as LOCKMAC_0, key_name as LOCKNAME,key_key as OPENWORD FROM $tableName WHERE user_id = $userId");//
    return result.toList();
  }

  //查询总数
  Future<int> getCount({int keyId=0}) async {
    var dbClient = await db;
    if(keyId>0)
      return Sqflite.firstIntValue(
          await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName where key_id = $keyId"));
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

//按照id查询
  Future<Map<String, dynamic>> getItem(int keyId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE key_id = $keyId");

    if (result.length == 0) return null;
    return result.first;
  }

  //清空数据
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }

  //根据id删除
  Future<int> deleteItem(int keyId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "key_id = ?", whereArgs: [keyId]);
  }

  //修改
  Future<int> updateItem(Map<String, dynamic> keyItem) async {
    var dbClient = await db;
    int res= await dbClient.update("$tableName", keyItem,
        where: "key_id = ?", whereArgs: [keyItem['key_id']]);

    return res;
  }

  //关闭
  Future close() async {
    var dbClient = await db;
    if(dbClient!=null)
      return dbClient.close();
  }
}

/*
class UserDb{
  var db = DatabaseHelper();

   return  await db.getItem(userid);

    await db.saveItem(user);

  }

}
*/
