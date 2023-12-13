import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class transaction_controller extends GetxController {
  Database? transaction_database;
  Database? _database;
  var dbName1 = 'total.db';
  var dbVersion1 = 1;
  var dbTableName1 = "totals";
  var dbName = 'TransactionDetail.db';
  var dbVersion = 1;
  var dbTableName = "Transactions";
  var isTransactionType = "".obs;
  var Data = [].obs;
  var CreditAmount = "0";
  var DebitAmount = "0";
  var Balance = "0";
  var amount = [].obs;

  TextEditingController date_controller = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  Transaction_Type({required var value}) {
    isTransactionType.value = value;
    update();
  }

  Future GetTransactionDatabase() async {
    if (transaction_database != null) {
      return transaction_database;
    } else {
      var dirdatabase = await getDatabasesPath();
      String path = join(dirdatabase, dbName);
      transaction_database = await openDatabase(
        path,
        version: dbVersion,
        onCreate: (Database db, int version) {
          db.execute(
              """CREATE TABLE $dbTableName (id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT NOT NULL,transaction_type TEXT NOT NULL,amount TEXT NOT NULL,reason TEXT,table_id INTEGER)""");
        },
      );
    }
  }

  InsertData({required var date,required var type,required var amount,required var reason,required int index}){
    String InsertQuery = """INSERT INTO $dbTableName VALUES(NULL,'$date','$type','$amount','$reason',$index)""";
    transaction_database!.rawInsert(InsertQuery);
  }

  Future GetData(int index) async{
    String GetDataQuery = """SELECT * FROM $dbTableName WHERE table_id = $index""";
    Data.value = await transaction_database!.rawQuery(GetDataQuery);
  }

  Future Edit_Data({required var date,required var type,required var amount,required var reason,required int index}) async{
    String EditQuery = """UPDATE $dbTableName SET date = '$date',transaction_type = '$type',amount = '$amount',reason = '$reason' WHERE id = $index;""";
    transaction_database!.rawUpdate(EditQuery);
  }

  Future DeleteData({required int index}) async{
    String DeleteQuery = """DELETE FROM $dbTableName WHERE id = '$index'""";
    transaction_database!.rawDelete(DeleteQuery);
  }

  Future DeleteTable({required int index}) async{
    String DeleteTableQuery = """DELETE FROM $dbTableName WHERE table_id = $index""";
    transaction_database!.rawDelete(DeleteTableQuery);
  }

  PickDate() async {
    DateTime ? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2500));
    if(pickedDate != null){
      date_controller.text = DateFormat('dd-MM-yyyy').format(pickedDate).toString();
    }
    else{
      date_controller.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    }
  }

  Future GetTotaldb() async {
    if(_database != null){
      return _database;
    }
    else{
      var dirdatabase = await getDatabasesPath();
      String path = join(dirdatabase,dbName1);
      _database = await openDatabase(path,version: dbVersion1,onCreate: (Database db, int version) {
        db.execute("""CREATE TABLE $dbTableName1 (id INTEGER PRIMARY KEY AUTOINCREMENT,credit TEXT,debit TEXT,balance TEXT)""");
      },);
    }
  }

  Future TotalAll(int id) async{
    double credit = 0;
    double debit = 0;
    for(int i = 0; i < Data.length; i++){
      if(Data[i]['transaction_type'] == "Credit"){
        credit = double.parse(Data[i]['amount']) + credit;
      }
      else{
        debit = double.parse(Data[i]['amount']) + debit;
      }
    }
    CreditAmount = credit.toStringAsFixed(2);
    DebitAmount = debit.toStringAsFixed(2);
    double total = credit - debit;
    Balance = total.toStringAsFixed(2);

    String UpdateQuery = """UPDATE $dbTableName1 SET credit = '$CreditAmount',debit = '$DebitAmount',balance = '$Balance' WHERE id = $id;""";
    _database!.rawUpdate(UpdateQuery);
  }

  Future SelectQuery() async {
    String showAmount = """SELECT * FROM $dbTableName1""";
    amount.value = await _database!.rawQuery(showAmount);
  }

  Future DeleteAmount(int id) async {
    String DeleteAmountQuery = """DELETE FROM $dbTableName1 WHERE id = $id;""";
    _database!.rawDelete(DeleteAmountQuery);
  }

  Future InsertAmountData() async {
    String InsertAmountQuery = """INSERT INTO $dbTableName1 VALUES(NULL,'0','0','0')""";
    _database!.rawInsert(InsertAmountQuery);
  }
}
