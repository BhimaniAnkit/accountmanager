
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'account_controller.dart';

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

  account_controller accountController = account_controller();

  TextEditingController date_controller = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  Transaction_Type({required var value}) {
    isTransactionType.value = value;
    update();
  }

  Future<void> shareTransactionDetailsAsPDF(int ac_Name) async {
    final account_name = await GetData(ac_Name);
    // print("Account id:= $account_name");
    // await getDataByAccountName(ac_Name.toString());

    if (account_name != null) {
      // print("Account id:= $account_name");

      if (Data.isEmpty || ac_Name < 0 || ac_Name >= Data.length) {
        print('Invalid index or empty list.');
        return;
      }

      // Calculate total values before generating the PDF
      await TotalAll(ac_Name);

      final pdfFile = await generateTransactionPDF(ac_Name, Data.cast<Map<String, dynamic>>(), accountController);

      final directory = await getApplicationDocumentsDirectory();
      final pdfPath = '${directory.path}/account_transaction_details.pdf';
      File(pdfPath).writeAsBytesSync(await pdfFile.readAsBytes());

      Share.shareFiles([pdfPath],
          text: 'Transaction details for ${Data[ac_Name]['acname']}');
    }
    else {
      print('No data found for the given index.');
    }
  }

  Future<File> generateTransactionPDF(int ac_name, List<Map<String, dynamic>> transactions, account_controller accountController) async {
    final pdf = pw.Document();

    if (transactions.isNotEmpty && ac_name >= 0 && ac_name < transactions.length) {
      final accountName = transactions[ac_name]['acname'] ?? 'Unknown Account';

      final accountData = await accountController.GetDatabase();
      await accountController.GetData();

      // Find the actual account name from the account controller
      final actualAccountName = accountController.DataList.firstWhere(
            (account) => account['id'] == ac_name + 1,
        orElse: () => {'acname': 'Unknown Account'},
      )['acname'];

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Transaction Details for ${actualAccountName}', style: pw.TextStyle(font: pw.Font.timesBold())),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Date',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Transaction Type',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Amount',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Reason',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    for (var transaction in transactions)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(transaction['date'] ?? '',style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(transaction['transaction_type'] ?? '',style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(transaction['amount'] ?? '',style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(transaction['reason'] ?? '',style: pw.TextStyle()),
                          ),
                        ],
                      ),
                  ],
                ),
                pw.SizedBox(height: 10),
                generateTotalInfoTable(),
              ],
            );
          },
        ),
      );

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final pdfPath = '${directory.path}/account_transaction_details.pdf';
      final file = File(pdfPath);
      await file.writeAsBytes(await pdf.save());

      return file;
    } else {
      print('Invalid index or empty list.');
      return File(''); // You can handle the case when the PDF file is not generated successfully.
    }
  }

  pw.Table generateTotalInfoTable(){
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text('Total Debit',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text('Total Credit',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text('Balance',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text(CreditAmount,style: pw.TextStyle()),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text(DebitAmount,style: pw.TextStyle()),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text(Balance,style: pw.TextStyle()),
            ),
          ],
        ),
      ],
    );
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

  double getTotalCredit(){
    double totalCredit = 0.0;
    for(int i = 0; i < amount.length; i++){
      totalCredit += amount[i]['credit'];
    }
    return totalCredit;
  }

  double getTotalDebit(){
    double totalDebit = 0.0;
    for(int i = 0; i < amount.length; i++){
      totalDebit += amount[i]['debit'];
    }
    return totalDebit;
  }

  InsertData({required var date,required var type,required var amount,required var reason,required int index}){
    String InsertQuery = """INSERT INTO $dbTableName VALUES(NULL,'$date','$type','$amount','$reason',$index)""";
    transaction_database!.rawInsert(InsertQuery);
  }

  Future<String?> GetData(int index) async {
    String GetDataQuary = """SELECT * FROM $dbTableName WHERE table_id=$index """;
    List<Map<String, dynamic>> result = await transaction_database!.rawQuery(GetDataQuary);

    // Check if there is data in the list
    if (result.isNotEmpty) {
      // Return the account name from the first item in the list
      Data.value = result;
      // Return the account name from the first item in the list
      return "Data Found";
    } else {
      // If there is no data, return null
      return null;
    }
  }

  // Future GetData(int index) async{
  //   String GetDataQuery = """SELECT * FROM $dbTableName WHERE table_id = $index""";
  //   Data.value = await transaction_database!.rawQuery(GetDataQuery);
  // }

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

  Future<Map<String, double>> TotalAll(int id) async {
    double credit = 0;
    double debit = 0;
    for(int i = 0; i < Data.length; i++){
      if(Data[i]['transaction_type'] == "Credit"){
        credit = double.parse(Data[i]['amount']) + credit;
      } else {
        debit = double.parse(Data[i]['amount']) + debit;
      }
    }
    CreditAmount = credit.toStringAsFixed(2);
    DebitAmount = debit.toStringAsFixed(2);
    double total = credit - debit;
    Balance = total.toStringAsFixed(2);

    String UpdateQuery = """UPDATE $dbTableName1 SET credit = '$CreditAmount',debit = '$DebitAmount',balance = '$Balance' WHERE id = $id;""";
    await _database!.rawUpdate(UpdateQuery);

    return {'credit': credit, 'debit': debit, 'balance': total};
  }

  // Future TotalAll(int id) async{
  //   double credit = 0;
  //   double debit = 0;
  //   for(int i = 0; i < Data.length; i++){
  //     if(Data[i]['transaction_type'] == "Credit"){
  //       credit = double.parse(Data[i]['amount']) + credit;
  //     }
  //     else{
  //       debit = double.parse(Data[i]['amount']) + debit;
  //     }
  //   }
  //   CreditAmount = credit.toStringAsFixed(2);
  //   DebitAmount = debit.toStringAsFixed(2);
  //   double total = credit - debit;
  //   Balance = total.toStringAsFixed(2);
  //
  //   String UpdateQuery = """UPDATE $dbTableName1 SET credit = '$CreditAmount',debit = '$DebitAmount',balance = '$Balance' WHERE id = $id;""";
  //   _database!.rawUpdate(UpdateQuery);
  // }

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
