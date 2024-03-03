import 'dart:io';
import 'package:accountmanager/Controller/account_controller.dart';
import 'package:accountmanager/Controller/transaction_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share/share.dart';

class Transaction extends StatelessWidget {

  int ac_name;
  Transaction(this.ac_name);

  TextEditingController amount_controller = TextEditingController();
  TextEditingController reason_controller = TextEditingController();

  account_controller ac = Get.put(account_controller());
  transaction_controller tc = Get.put(transaction_controller());

  @override
  Widget build(BuildContext context) {
    tc.GetTransactionDatabase().then((value) {
      return tc.GetData(ac_name).then((value) => tc.SelectQuery());
    },);

    // List<PieChartSectionData> getSections(){
    //   // Assuming you have data for credit and debit in tc.amount[ac_name]['credit'] and tc.amount[ac_name]['debit']
    //   double credit = double.parse(tc.amount[ac_name]['credit' ?? "0"]);
    //   double debit = double.parse(tc.amount[ac_name]['debit'] ?? "0");
    //
    //   return List.generate(2, (index) {
    //     switch(index){
    //       case 0:
    //         return PieChartSectionData(
    //           color: Colors.green,
    //           value: credit,
    //           title: 'Credit',
    //           radius: 50.0,
    //           titleStyle: TextStyle(
    //             fontSize: 14,
    //             fontWeight: FontWeight.bold,
    //             color: Color(0xffffffff),
    //           ),
    //         );
    //       case 1:
    //         return PieChartSectionData(
    //           color: Colors.red,
    //           value: debit,
    //           title: 'Debit',
    //           radius: 50.0,
    //           titleStyle: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 14,
    //             color: Color(0xffffffff),
    //           ),
    //         );
    //       default:
    //         throw Exception('Invalid Index');
    //     }
    //   });
    // }

    Widget displayTransactionChart(){
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            groupsSpace: 12.0,
            titlesData: FlTitlesData(
              leftTitles: SideTitles(showTitles: true),
              bottomTitles: SideTitles(showTitles: true),
            ),
            borderData: FlBorderData(
              show: true,
            ),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    y: tc.amount[ac_name]['credit'],
                    colors: [Colors.green],
                  ),
                  BarChartRodData(
                    y: tc.amount[ac_name]['debit'],
                    colors: [Colors.red],
                  ),
                  BarChartRodData(
                    y: tc.amount[ac_name]['balance'],
                    colors: [Colors.purple],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${ac.DataList[ac_name]['acname']}"),
        actions: [
          IconButton(
            onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context, builder: (context) {
              return TransactionDialog();
            },);
          }, icon: Icon(Icons.add_circle_outlined)),
          SizedBox(width: 10,),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          SizedBox(width: 10,),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          IconButton(onPressed: () {
            tc.shareTransactionDetailsAsPDF(ac_name);
          }, icon: Icon(Icons.share)),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Column(
            children: [
              // Display Chart
              Container(
                height: 200,
                // child: displayTransactionChart(),
                padding: EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: double.parse(tc.amount[ac_name]['credit']),
                            colors: [Colors.green],
                          ),
                          BarChartRodData(
                            y: double.parse(tc.amount[ac_name]['debit']),
                            colors: [Colors.red],
                          ),
                          BarChartRodData(
                            y: double.parse(tc.amount[ac_name]['balance'] ?? 0),
                            colors: [Colors.purple],
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(showTitles: true),
                      bottomTitles: SideTitles(showTitles: true),
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                  ),
                ),
              ),

              Container(
                // height: 200,
                color: Colors.black12,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Particular",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Credit(₹)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Debit(₹)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    // displayTransactionChart(),
                  ],
                  // Display Chart
                  // displayTransactionChart(),
                ),
              ),
              Expanded(child: Obx(() => ListTransaction())),
            ],
          ),),
          Card(
            child: Container(
              height: 80,
              child: Row(
                children: [
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Credit(↑)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() =>
                            Text("₹ ${tc.amount[ac_name]['credit']}",
                                style: TextStyle(fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Debit(↓)",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Obx(() =>
                                Text("₹ ${tc.amount[ac_name]['debit']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      )),
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    color: Colors.purple,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Balance",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Obx(() =>
                            Text(
                              "₹ ${tc.amount[ac_name]['balance']}",
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget ListTransaction() {
      return ListView.builder(
        itemCount: tc.Data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTapDown: (details) {
              showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      0, details.globalPosition.dy, details.globalPosition.dx, 0),
                  items: [
                    PopupMenuItem(
                        onTap: () {
                          tc.date_controller.text = tc.Data[index]['date'];
                          tc.isTransactionType.value = tc.Data[index]['transaction_type'];
                          amount_controller.text = tc.Data[index]['amount'];
                          reason_controller.text = tc.Data[index]['reason'];
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => EditTransactionDialog(index));
                        },
                        child: Text("Edit")),
                    PopupMenuItem(
                        onTap: () {
                          tc.DeleteData(index: tc.Data[index]['id'])
                              .then((value) => tc.GetData(ac_name))
                              .then((value) => tc.TotalAll(tc.amount[ac_name]['id']))
                              .then((value) => tc.SelectQuery());
                        },
                        child: Text("Delete"))
                  ]);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              color: (index % 2 == 1) ? Colors.black12 : Colors.white,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Obx(() => Text(
                        tc.Data[index]['date'],
                        style: TextStyle(
                            fontSize: 15,
                            color: (tc.Data[index]['transaction_type'] ==
                                "Credit")
                                ? Colors.green
                                : Colors.red),
                        softWrap: true,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(delay: 300.ms)
                          .move(delay: 300.ms,duration: 600.ms)
                          .then(duration: 600.ms,delay: 300.ms,curve: Cubic(10.0, 10.0, 10.0, 10.0))
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Obx(() => Text(
                        tc.Data[index]['reason'],
                        style: TextStyle(
                            fontSize: 15,
                            color: (tc.Data[index]['transaction_type'] ==
                                "Credit")
                                ? Colors.green
                                : Colors.red),
                        softWrap: true,
                      ))),
                  Spacer(),
                  Expanded(
                      child: Obx(
                              () => (tc.Data[index]['transaction_type'] == "Credit")
                              ? Text(
                            tc.Data[index]['amount'],
                            style: TextStyle(
                                fontSize: 15,
                                color: (tc.Data[index]
                                ['transaction_type'] ==
                                    "Credit")
                                    ? Colors.green
                                    : Colors.red),
                            softWrap: true,
                          )
                              : Text(
                            "0",
                            style: TextStyle(
                                fontSize: 15,
                                color: (tc.Data[index]
                                ['transaction_type'] ==
                                    "Credit")
                                    ? Colors.green
                                    : Colors.red),
                          ))),
                  Spacer(),
                  Expanded(
                      child: Obx(
                              () => (tc.Data[index]['transaction_type'] == "Debit")
                              ? Text(
                            tc.Data[index]['amount'],
                            style: TextStyle(
                                fontSize: 15,
                                color: (tc.Data[index]
                                ['transaction_type'] == "Credit")
                                    ? Colors.green
                                    : Colors.red),
                            softWrap: true,
                          )
                              : Text(
                            "0",
                            style: TextStyle(
                                fontSize: 15,
                                color: (tc.Data[index]
                                ['transaction_type'] ==
                                    "Credit")
                                    ? Colors.green
                                    : Colors.red),
                          ))),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget TransactionDialog() {
      return AlertDialog(
        content: SizedBox(
          height: 350,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 300,
                color: Colors.purple,
                child: Text(
                  "Add transaction",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              TextField(
                controller: tc.date_controller,
                onTap: () {
                  tc.PickDate();
                },
                keyboardType: TextInputType.none,
                decoration: InputDecoration(labelText: "Transaction Date"),
              ),
              Row(
                children: [
                  Text("Transaction type: "),
                  Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                                () => Radio(
                              activeColor: Colors.deepOrange.shade700,
                              value: "Credit",
                              groupValue: tc.isTransactionType.value,
                              onChanged: (value) {
                                tc.Transaction_Type(value: value);
                              },
                            ),
                          ),
                          Text("Credit(+)"),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(
                                () => Radio(
                              value: "Debit",
                              activeColor: Colors.deepOrange.shade700,
                              groupValue: tc.isTransactionType.value,
                              onChanged: (value) {
                                tc.Transaction_Type(value: value);
                              },
                            ),
                          ),
                          Text("Debit(-)"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              TextField(
                keyboardType: TextInputType.number,
                
                decoration: InputDecoration(labelText: "Amount",isDense: true,),
                controller: amount_controller,
                style: TextStyle(color: HexColor("990099"),),
              ),
              TextField(
                controller: reason_controller,
                decoration: InputDecoration(labelText: "Particular"),
              ),
            ],
          ),
        ),
        actions: [
          // OutlinedButton(
          FilledButton(
              style: ButtonStyle(
                  side: MaterialStatePropertyAll(
                      BorderSide(width: 2, color: Colors.purple)),
                  animationDuration: Duration(milliseconds: 500),
                  fixedSize: MaterialStatePropertyAll(Size(140.0, 10.0)),
                backgroundColor: MaterialStatePropertyAll(Colors.white)
              ),
              onPressed: () {
                tc.GetData(ac_name);
                tc.date_controller.text = "";
                tc.isTransactionType.value = "";
                amount_controller.clear();
                reason_controller.clear();
                Navigator.pop(Get.context!);
              },
              child: Text("CANCEL",style: TextStyle(color: HexColor("990099")),)),
          // ElevatedButton(
          FilledButton(
              onPressed: () {
                if (tc.date_controller != "" &&
                    tc.isTransactionType.value != "" &&
                    amount_controller.text != "") {
                  tc.InsertData(
                      index: ac_name,
                      date: tc.date_controller.text,
                      type: tc.isTransactionType,
                      amount: amount_controller.text,
                      reason: (reason_controller.text != "") ? reason_controller.text : "No Reason",
                      );
                  tc.GetData(ac_name)
                      .then((value) => tc.TotalAll(tc.amount[ac_name]['id']))
                      .then((value) => tc.SelectQuery());
                  tc.date_controller.text = "";
                  tc.isTransactionType.value = "";
                  amount_controller.clear();
                  reason_controller.clear();
                  Get.back();
                } else {
                  Get.snackbar("Error", "Fill all required field",
                      colorText: Colors.white,
                      backgroundColor: Colors.purple,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(milliseconds: 1000),
                      margin: EdgeInsets.all(50));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(HexColor("990099")),
                animationDuration: Duration(milliseconds: 500),
                fixedSize: MaterialStatePropertyAll(Size(140.0, 10.0))
                // shape: MaterialStatePropertyAll(BoxShape.circle),
              ),
              child: Text(
                "ADD",
                style: TextStyle(color: Colors.white),
              ))
        ],
      );
    }

    Widget EditTransactionDialog(int index) {
      return AlertDialog(
        content: SizedBox(
          height: 350,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 300,
                color: Colors.purple,
                child: Text(
                  "Edit transaction",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              TextField(
                controller: tc.date_controller,
                onTap: () {
                  tc.PickDate();
                },
                keyboardType: TextInputType.none,
                decoration: InputDecoration(labelText: "Transaction Date"),
              ),
              Row(
                children: [
                  Text("Transaction type: "),
                  Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                                () =>
                                Radio(
                                  activeColor: Colors.purple,
                                  value: "Credit",
                                  groupValue: tc.isTransactionType.value,
                                  onChanged: (value) {
                                    tc.Transaction_Type(value: value);
                                  },
                                ),
                          ),
                          Text("Credit(+)"),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(
                                () =>
                                Radio(
                                  value: "Debit",
                                  groupValue: tc.isTransactionType.value,
                                  onChanged: (value) {
                                    tc.Transaction_Type(value: value);
                                  },
                                ),
                          ),
                          Text("Debit(-)"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
                controller: amount_controller,
              ),
              TextField(
                controller: reason_controller,
                decoration: InputDecoration(labelText: "Particular"),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
              style: ButtonStyle(
                  side: MaterialStatePropertyAll(
                      BorderSide(width: 2, color: Colors.purple))),
              onPressed: () {
                tc.GetData(ac_name);
                tc.date_controller.text = "";
                tc.isTransactionType.value = "";
                amount_controller.clear();
                reason_controller.clear();
                Navigator.pop(Get.context!);
              },
              child: Text("CANCEL")),
          ElevatedButton(
              onPressed: () {
                if (tc.date_controller != "" &&
                    tc.isTransactionType.value != "" &&
                    amount_controller.text != "") {
                  tc.Edit_Data(
                    index: tc.Data[index]['id'],
                    date: tc.date_controller.text,
                    type: tc.isTransactionType,
                    amount: amount_controller.text,
                    reason: (reason_controller.text != "") ? reason_controller
                        .text : "No Reason",
                  );
                  tc.GetData(ac_name)
                      .then((value) => tc.TotalAll(tc.amount[ac_name]['id']))
                      .then((value) => tc.SelectQuery());
                  tc.date_controller.text = "";
                  tc.isTransactionType.value = "";
                  amount_controller.clear();
                  reason_controller.clear();
                  Get.back();
                } else {
                  Get.snackbar("Error", "Fill all required field",
                      colorText: Colors.white,
                      backgroundColor: Colors.purple,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(milliseconds: 1000),
                      margin: EdgeInsets.all(50));
                }
              },
              child: Text(
                "SAVE",
                style: TextStyle(color: Colors.white),
              ))
        ],
      );
    }
}
