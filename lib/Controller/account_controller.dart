import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class account_controller extends GetxController{
  Database? account_database;

  var dbName = "Account.db";
  var dbVersion = 1;
  var dbTable = "Accounts";

  RxList<dynamic> DataList = [].obs;

  Future GetDatabase() async {
    if(account_database != null){
      return account_database;
    }
    else{
      var dbDir = await getDatabasesPath();
      String path = join(dbDir,dbName);
      account_database = await openDatabase(path,version: 1,onCreate: (Database db,int version) {
        db.execute("""CREATE TABLE $dbTable (id INTEGER PRIMARY KEY AUTOINCREMENT,acname TEXT NOT NULL)""");
      });
    }
  }
  Future GetData() async {
    String SelectQuery = """SELECT * FROM $dbTable""";
    DataList.value = await account_database!.rawQuery(SelectQuery);
  }
  
  Future DataInsert({required String name}) async{
    String InsertData = """INSERT INTO $dbTable VALUES(NULL,'$name')""";
    account_database!.rawInsert(InsertData);
  }
  
  Future UpdateData({required String updateName,required int index}) async{
    String UpdateQuery = """UPDATE $dbTable SET acname = '$updateName' WHERE id = $index;""";
    account_database!.rawUpdate(UpdateQuery).then((value) => GetData());
  }
  
  Future DeleteData({required int index}) async{
    String DeleteData = """DELETE From $dbTable WHERE id = $index""";
    account_database!.rawDelete(DeleteData).then((value) => GetData());
  }
}
